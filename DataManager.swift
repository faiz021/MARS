//
//  DataManager.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 03/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit

class DataManager{

    var bookSet = [Books]()
    var cdSet = [CDData]()
    var dvdSet = [DVDData]()
  
    typealias BookData = (Any?, Bool)->()
    typealias CD_Data = (Any?, Bool)->()
    typealias DVD_Data = (Any?, Bool)->()
    
    func requestBookData(isbn:String, completion: @escaping BookData){
    
        let url = URL(string: "http://isbndb.com/api/v2/json/9YHFO0NA/book/"+isbn)
        
        let dataTask = URLSession.shared.dataTask(with: url!){
            (data, response, error)in self.didFetchBookData(data: data, response: response!, downloadError: error, completion: completion)
        }
        dataTask.resume()
    }
    
    func requestCDData(barcode:String, completion: @escaping CD_Data){
        print("BARCODE: ", barcode)
        let key = "tWveQoWGzLNLzEdiAzRe"
        let secret = "wWblCOIvEfKqyMkyvsMsqQRSdELwEgsg"
        let url = URL(string: "https://api.discogs.com/database/search?q="+barcode+"&key="+key+"&secret="+secret)
        
        let dataTask = URLSession.shared.dataTask(with: url!){
            (data, response, error)in self.didFetchCDData(data: data, response: response!, downloadError: error, completion: completion)
        }
        dataTask.resume()
    }
    
    
    func requestDVDData(name:String, completion: @escaping DVD_Data){
        let key = "a77cf2d9d9213c8f2583a2399764d830"
        var strURL = "http://api.themoviedb.org/3/search/movie?query=&query="+name+"&api_key="+key
        strURL = strURL.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let url = URL(string:strURL)
      
        print("URL: ",url)
        let dataTask = URLSession.shared.dataTask(with: url!){
            (data, response, error)in self.didFetchDVDData(data: data, response: response!, downloadError: error, completion: completion)
        }
        dataTask.resume()
    }
    
    
    func didFetchBookData(data:Data?, response: URLResponse, downloadError: Error?, completion:@escaping BookData){
    
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]{
                if let bookItems = json["data"] as? [[String:Any]]{
                    
                    for bookdata in bookItems{
                        
                        let info = bookdata as [String:Any]
                        
                        if let title = info["title"] as? String {
                            Books.sharedInstance.title = title
                            print("TITLE: ",title)
                        }
                        if let publisher = info["publisher_name"] as? String {
                            Books.sharedInstance.publisher = publisher
                            print("PUBLISHER: ",publisher)
                        }
                        
                        if let authors = info["author_data"] as? [[String:Any]]!{
                            for author in authors {
                                let authorInfo = author as [String:Any]
                                
                                if let name = authorInfo["name"] as? String{
                                    Books.sharedInstance.author = name
                                    print("AUTHOR: ", name)
                                }
                            }
                        }
                        
                        bookSet.append(Books.sharedInstance)
                        
                    }
                    completion(bookSet, true)
                }
            }
        }catch{
            print("ERROR: ", error.localizedDescription)
        }

    }
    
    func didFetchCDData(data:Data?, response: URLResponse, downloadError: Error?, completion:@escaping CD_Data){
        
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]{
                if let cdItems = json["results"] as? [[String:Any]]{
                    print("DATA: ", cdItems)
                    for data in cdItems{
                        let cd = CDData()
                        
                        let info = data as [String:Any]
                        
                        if let title = info["title"] as? String {
                            cd.title = title
                            print("TITLE: ",title)
                        }
                        
                        if let genres = info["genre"] as? [String]!{
                            for genre in genres {
                                cd.genre = [genre]
                                //CDData.sharedInstance.genre = [genre]
                                
                            }
                            print("GENRE: ", genres)
                        }
                        
                        if let country = info["country"] as? String {
                            cd.country = country
                            //CDData.sharedInstance.country = country
                            print("COUNTRY: ",country)
                        }
                        
                        if let year = info["year"] as? String {
                            cd.year = year
                            //CDData.sharedInstance.year = year
                            print("YEAR: ",year)
                        }
                        
                        if let img = info["thumb"] as? String {
                            cd.img_url = img
                            //CDData.sharedInstance.img_url = img
                            print("IMG: ", img)
                        }
    
                        cdSet.append(cd)
                        
                    }
                    completion(cdSet, true)
                }
            }
        }catch{
            print("ERROR: ", error.localizedDescription)
        }
        
    }

    func didFetchDVDData(data:Data?, response: URLResponse, downloadError: Error?, completion:@escaping DVD_Data){
        
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]{
                if let cdItems = json["results"] as? [[String:Any]]{
                    print("DATA: ", cdItems)
                    for data in cdItems{
                        let dvd = DVDData()
                        
                        let info = data as [String:Any]
                        
                        if let title = info["title"] as? String {
                            dvd.title = title
                            print("TITLE: ",title)
                        }
                        
                        if let year = info["release_date"] as? String {
                            dvd.year = year
                            //CDData.sharedInstance.year = year
                            print("YEAR: ",year)
                        }
                        
                        if let img = info["poster_path"] as? String {
                            dvd.img_url = "https://image.tmdb.org/t/p/w92"+img
                            print("IMG: ", img)
                        }
                        
                        dvdSet.append(dvd)
                        
                    }
                    completion(dvdSet, true)
                }
            }
        }catch{
            print("ERROR: ", error.localizedDescription)
        }
        
    }

    
    
  

}
