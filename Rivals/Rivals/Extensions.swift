//
//  Extensions.swift
//  Rivals
//
//  Created by Nate Lentz on 4/16/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String){
        
        self.image = nil
        
        // Check cache for image
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // Otherwise, go download and cache the image
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            // Help images show up immediately
            DispatchQueue.main.async(execute: {
                if let imageToCache = UIImage(data: data!) {
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    
                    self.image = imageToCache
                }
            })
        }).resume()
    }
}
