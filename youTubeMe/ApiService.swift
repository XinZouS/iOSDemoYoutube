//
//  ApiService.swift
//  youTubeMe
//
//  Created by Xin Zou on 3/17/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class ApiService: NSObject {

    static let sharedInstance = ApiService()
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) { // add a completion func block;
        
//        fetchFeedForUrlString(urlSession: "home.json") { (videos) in
//            completion(videos)
//        }
        // above func can be simplify as one lien:
        fetchFeedForUrlString(urlSession: "home.json", completion: completion)
    }

    func fetchTrendingFeeds(completion: @escaping ([Video]) -> ()) { // add a completion func block;
        
        fetchFeedForUrlString(urlSession: "trending.json") { (videos) in
            completion(videos)
        }
    }

    func fetchSubscriptionFeeds(completion: @escaping ([Video]) -> ()) { // add a completion func block;
        
        fetchFeedForUrlString(urlSession: "subscriptions.json") { (videos) in
            completion(videos)
        }
    }
    
    
    
    let basicUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets/"
    
    func fetchFeedForUrlString(urlSession: String, completion: @escaping ([Video]) -> ()) {
        let url = NSURL(string: "\(basicUrl)\(urlSession)")
        let request = URLRequest(url: url as! URL)
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            if err != nil {
                print("get error when fetching videos: ApiService.swift")
                return
            }
            
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            do {
                if let unwrappedData = data, let jsonDictionarys = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String : AnyObject]] {
                    
////                    var videos = [Video]()
////                    for dictionary in jsonDictionarys {
////                        // print(dictionary)
////                        let video = Video(dictionary: dictionary) // replace All video setup lines
////                        videos.append(video)
////                    }
//                    let videos = jsonDictionarys.map({ return Video(dictionary: $0) })
                    // even make it less: put above line into completion:
                    DispatchQueue.main.async(execute: {
//                        completion(videos)
                        completion(jsonDictionarys.map({ return Video(dictionary: $0) }))
                    })

                }

            }catch let jsonErr {
                print("get error when parsing JSON data: \(jsonErr)")
            }
            
        }.resume()
    }

    // replace above by following lines for above code: easier json save;
    //            do {
    //                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
    //
    //                var videos = [Video]()
    //
    //                for dictionary in json as! [[String : AnyObject]] {
    //                    // print(dictionary)
    //
    //                    let video = Video(title: "testTitle")
    // setup by init-+->  // let video = Video(dictionary: dictionary)
    //               |    video.title = dictionary["title"] as? String
    //               |    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
    //               |    video.numberOfViews = dictionary["number_of_views"] as? NSNumber
    //               |    video.duration = dictionary["duration"] as? NSNumber
    // setup one line+->  //video.setValuesForKeys(dictionary) // replace above 4 lines by this one;
    //
    // mov these in-+-->  let channel = Channel()
    // Video.swift  |     if let getChannel = dictionary["channel"] as? [String: AnyObject] {
    // for setup;   |         channel.name = getChannel["name"] as? String
    //              |         channel.profileImageName = getChannel["profile_image_name"] as? String
    //              |         video.channel = channel
    //              +-->  }
    //
    //                    videos.append(video)
    //                }
    //                DispatchQueue.main.async(execute: {
    //                    completion(videos)
    //                })
    //
    //            }catch let jsonErr {
    //                print("get error when parsing JSON data: \(jsonErr)")
    //            }

    
}
