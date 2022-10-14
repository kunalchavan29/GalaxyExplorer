//
//  CustomImageView.swift
//  GalaxyExplorer
//
//  Created by A118830248 on 14/10/22.
//

import UIKit

class CustomImageView: UIImageView {
    
    // MARK: - Constants
    let imageCache = NSCache<NSString, AnyObject>()
    
    var imageURL: URL?
    
    let activityIndicator = UIActivityIndicatorView()
    
    func loadImageWithUrl(_ url: URL, completion: @escaping ((UIImage)-> Void)) {
        
        // setup activityIndicator...
        activityIndicator.color = .darkGray
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageURL = url
        
        image = nil
        activityIndicator.startAnimating()
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        
        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }
            
            if let unwrappedData = data,
               let image = UIImage(data: unwrappedData),
               let compressedData = image.jpegData(compressionQuality: 1),
               let compressedImage = UIImage(data: compressedData) {
                
                DispatchQueue.main.async {
                    
                    if self.imageURL == url {
                        self.image = compressedImage
                        
                        let aspectRatio = compressedImage.size.height/compressedImage.size.width
                        let imageHeight = (self.frame.width) * aspectRatio
                        rowHeights[url.absoluteString] = imageHeight
                        completion(compressedImage)
                    }
                    
                    self.imageCache.setObject(compressedImage, forKey: url.absoluteString as NSString)
                    self.activityIndicator.stopAnimating()
                }
            }
        }).resume()
    }
}
