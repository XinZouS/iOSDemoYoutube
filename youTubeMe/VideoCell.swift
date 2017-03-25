//
//  VideoCell.swift
//  youTubeMe
//
//  Created by Xin Zou on 1/31/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



// come from HomeController.swift
class VideoCell : BaseCollectionCell {
    
    var video : Video? {
        didSet {
            titleLabel.text = video?.title
            
            thumbnailImage.image = UIImage(named: (video?.thumbnail_image_name)!)
            
            setupThumbnailImage() // download img online insdead of use local resource

            setupProfileImage()
            
            if let getChannel = video?.channel {
            //guard let getChannel = video?.channel else {return}
                if let getProfileImageName = getChannel.profile_image_name {
                    profileImage.image = UIImage(named: getProfileImageName)
                }

                guard let getChannelName = getChannel.name, let nv = video?.number_of_views else {return}

                let numberFormatter = NumberFormatter()     // for 99,999,999,999
                numberFormatter.numberStyle = .decimal
                
                    let subText = "\(getChannelName) - \(numberFormatter.string(from: nv)!) views"
                    subtitleTextView.text = subText
//                    print("get channel name \(subtitleTextView.text!)")

//                if let date = video?.uploadDate {
//                    subtitleTextView.text = "l\(subtitleTextView.text) - \(date)"
//                }
            }
            
            // measure titleLabel box: 
            if let title = video?.title {
                let size = CGSize(width: (frame.width - 86), height: 100) // 86: margin size
                let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let attribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: option, attributes: attribute, context: nil)
                
                if estimatedRect.size.height > 26 {
                    titleLabelHeightConstraint?.constant = 46
                }else{
                    titleLabelHeightConstraint?.constant = 23
                }
                
            }
            
        }
    }
    
    // 8. add cell components:
    let thumbnailImage : CustomImageView = { // make sure image goes into the right cell, use customClass;
        let i = CustomImageView()
        //i.backgroundColor = .green
        i.image = #imageLiteral(resourceName: "Anna_Disney")
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        return i
    }()
    
    let profileImage : CustomImageView = {
        let i = CustomImageView()
        //i.backgroundColor = .orange
        i.image = #imageLiteral(resourceName: "Anna")
        i.contentMode = .scaleAspectFill
        //i.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        i.layer.cornerRadius = 26
        i.clipsToBounds = true
        return i
    }()
    
    let titleLabel : UILabel = {
        let t = UILabel()
        //t.backgroundColor = .blue
        t.text = "Anna - Frozen - Pixar"
        t.font = UIFont.boldSystemFont(ofSize: 16)
        t.numberOfLines = 2
        t.backgroundColor = .clear
        return t
    }()
    
    let subtitleTextView : UITextView = {
        let t = UITextView()
        //t.backgroundColor = .purple
        t.text = "Frozen: one of the best Disney movie, view: 70,253,268"
        t.isEditable = false
        t.font = UIFont.systemFont(ofSize: 14)
        t.textColor = UIColor.lightGray //(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        t.textContainerInset = UIEdgeInsetsMake(0, -6, 0, 0)
        t.backgroundColor = .clear
        return t
    }()
    
    var titleLabelHeightConstraint : NSLayoutConstraint?
    
    // 6. setup our Cell:
    override func setupCell(){
        self.backgroundColor = UIColor.white
        
        // 9. add component:
        addSubview(thumbnailImage)
        let thumbnailImageHeight = (frame.width - 20) / (16/9)
        //thumbnailImage.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 150)
        thumbnailImage.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 10, bottomConstent: 0, width: 0, height: thumbnailImageHeight)
        
        addSubview(profileImage)
        profileImage.addConstraints(left: leftAnchor, top: thumbnailImage.bottomAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 52, height: 52)
        
        addSubview(titleLabel)
        titleLabel.addConstraints(left: profileImage.rightAnchor, top: thumbnailImage.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 10, topConstent: 6, rightConstent: 10, bottomConstent: 0, width: 0, height: 46)
        //print(titleLabel.constraints)
        titleLabelHeightConstraint = titleLabel.constraints[0] // NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 46)
        //addConstraint(titleLabelHeightConstraint!)
        
        addSubview(subtitleTextView)
        subtitleTextView.addConstraints(left: profileImage.rightAnchor, top: titleLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 10, topConstent: 1, rightConstent: 10, bottomConstent: 0, width: 0, height: 36)
        
    }
    
    private func setupThumbnailImage() {
        if let thumbnailImgUrl = video?.thumbnail_image_name {
            
            thumbnailImage.loadImageWithUrlString(urlString: thumbnailImgUrl)
            // use above to replace following:
//            let url = NSURL(string: thumbnailImgUrl)
//            let request = URLRequest(url: url as! URL)
//            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, err) in
//                if err != nil {
//                    print("get error when loading image from web: VideoCell.swift: \(err)")
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.thumbnailImage.image = UIImage(data: data!)
//                }
//                
//            }).resume()
            
        }
    }
    
    private func setupProfileImage() {
        if let profileImageUrl = video?.channel?.profile_image_name {
            profileImage.loadImageWithUrlString(urlString: profileImageUrl)
        }
        
    }


    
}

