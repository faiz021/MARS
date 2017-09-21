//
//  Extensions.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 30/07/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{

    func loadImageUsingCacheWithUrlString(urlString: String){
    print(urlString)
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        //otherwise download a new image
      
        if urlString != ""
        {
        
        let url = URL(string: urlString.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        
        
        self.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground, completed: { (image, error, type, url) in
            
            imageCache.setObject(image!, forKey: urlString as AnyObject)
        })
            
            /*
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data:data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
 
            
    }.resume()
 */
    }
        else{
            print("URL not FOUND")
        }
    }
 
    
}

