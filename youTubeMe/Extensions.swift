//
//  Extensions.swift
//  youTubeMe
//
//  Created by Xin Zou on 1/31/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


extension UIColor {
    static func rgb(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static let redYoutube = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1)
    static let grayYoutube = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
}



extension UIView {
    
    func addConstraints(left:NSLayoutXAxisAnchor? = nil, top:NSLayoutYAxisAnchor? = nil, right:NSLayoutXAxisAnchor? = nil, bottom:NSLayoutYAxisAnchor? = nil, leftConstent:CGFloat? = 0, topConstent:CGFloat? = 0, rightConstent:CGFloat? = 0, bottomConstent:CGFloat? = 0, width:CGFloat? = 0, height:CGFloat? = 0){
        
        var anchors = [NSLayoutConstraint]()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if left != nil {
            anchors.append(leftAnchor.constraint(equalTo: left!, constant: leftConstent!))
        }
        if top != nil {
            anchors.append(topAnchor.constraint(equalTo: top!, constant: topConstent!))
        }
        if right != nil {
            anchors.append(rightAnchor.constraint(equalTo: right!, constant: -rightConstent!))
        }
        if bottom != nil {
            anchors.append(bottomAnchor.constraint(equalTo: bottom!, constant: -bottomConstent!))
        }
        if let width = width, width > CGFloat(0) {
            anchors.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height, height > CGFloat(0) {
            anchors.append(heightAnchor.constraint(equalToConstant: height))
        }
        for anchor in anchors {
            anchor.isActive = true
        }
    }
    
}


let imageCache = NSCache<AnyObject, UIImage>()

class CustomImageView : UIImageView { // instead of using extension UIImageView, for make image go to the right cell; 
    
    var imageUrlString : String?
    
    func loadImageWithUrlString(urlString: String?) {
        guard let urlStr = urlString else { return }
        
        imageUrlString = urlStr
        
        if let imageFromCache = imageCache.object(forKey: urlStr as AnyObject) {
            self.image = imageFromCache
            return
        }
        // if not in cache, then download it from server:
        let url = NSURL(string: urlStr)
        let request = URLRequest(url: url as! URL)
        let urlSession = URLSession.shared.dataTask(with: request) { (data, response, err) in
            if err != nil {
                print("get err when loading image with url: ", err!)
                return
            }
            DispatchQueue.main.async { // load image and put it into cache:
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlStr {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlStr as AnyObject)
            }
        }
        urlSession.resume()

    }
 
}
