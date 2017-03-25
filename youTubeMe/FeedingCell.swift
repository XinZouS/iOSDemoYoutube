//
//  FeedingCell.swift
//  youTubeMe
//
//  Created by Xin Zou on 3/19/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class FeedingCell: BaseCollectionCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var videos : [Video]? // use it on 109
    
    let feedingCollectionCellId = "feedingCellId"
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .grayYoutube
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    func fecthVideos(){ // moved into ApiService; rewrite as following:
        ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
    override func setupCell() {
        super.setupCell()
        
        backgroundColor = .white

        addSubview(collectionView)
        collectionView.addConstraints(left:leftAnchor, top:topAnchor, right:rightAnchor, bottom:bottomAnchor, leftConstent:0, topConstent:0, rightConstent:0, bottomConstent:0, width:0, height:0)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: feedingCollectionCellId)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
        }
        
        fecthVideos()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedingCollectionCellId, for: indexPath) as! VideoCell
        if indexPath.item < (videos?.count)! {
            cell.video = videos?[indexPath.item]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = (frame.width - 10 - 10) / (16/9)
        return CGSize(width: self.frame.width, height: h + (20 + 66))
    }
    
    // for video playing page: 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLuncher = VideoLuncher() // NSObject
        videoLuncher.showVideoPlayer()
        
    }
    
}
