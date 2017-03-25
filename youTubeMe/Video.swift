//
//  Video.swift
//  youTubeMe
//
//  Created by Xin Zou on 2/1/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let uppercasedFirstChar = String(key.characters.first!).uppercased()
        let selectorStr : String = uppercasedFirstChar + key.substring(from: key.index(key.startIndex, offsetBy: 1))
        let selector = NSSelectorFromString("set\(selectorStr):") // check if Class has the property by its setter
        let responds = self.responds(to: selector) // check if the property has setter and getter;
        
        if !responds {
            return
        }
        super.setValue(value, forKey: key)
    }
    
    
}

class Video : SafeJsonObject {
    
    var thumbnail_image_name: String?
    var title : String?
    var number_of_views: NSNumber?
    var uploadDate: NSDate?
    var duration: NSNumber?
    
    var channel : Channel?
    
    
//    var num_likes: NSNumber?
    
    init(title:String) {
        self.title = title
    }
    
    init(thumbnailImageName: String, title: String, numberOfViews: NSNumber = 666666 , channel: Channel? = nil) {
        self.thumbnail_image_name = thumbnailImageName
        self.title = title
        self.number_of_views = numberOfViews
        //self.uploadDate = uploadDate
        
        self.channel = channel
    }
    
    init(dictionary: [String : AnyObject]) { // for ApiServices.swift init by json bojects
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    // reduce for ApiService.swift and parsing json here: 
    override func setValue(_ value: Any?, forKey key: String) {
        
        // chatch "no match for key xxx" error if the coming key-value does not match our Video(init), then return
        // yet a better way to do this is to put following as a new NSObject class, outside Video.swift
//        let uppercasedFirstChar = String(key.characters.first!).uppercased()
//        let selectorStr : String = uppercasedFirstChar + key.substring(from: key.index(key.startIndex, offsetBy: 1))
//        let selector = NSSelectorFromString("set\(selectorStr)")
//        let responds = self.responds(to: selector)
//        
//        if !responds {
//            return
//        }
        
        
        // begin setup dictionary fro
        if key == "channel" { // call channel setup, from Video.swift;
            
//              channel.name = getChannel["name"] as? String
//              channel.profileImageName = getChannel["profile_image_name"] as? String
                self.channel = Channel()
                self.channel?.setValuesForKeys(value as! [String: AnyObject]) // replace above 2 lines by this one;

        }else{
            super.setValue(value, forKey: key)
        }
    }
    
}



class Channel : SafeJsonObject {
    
    var name: String?
    var profile_image_name: String?
    
    
    init(name: String? = "Anna - Disney Animation", profileImageName: String? = "Anna") {
        self.name = name
        self.profile_image_name = profileImageName
    }
    
}


