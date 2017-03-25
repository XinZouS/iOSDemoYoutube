//
//  TrendingCell.swift
//  youTubeMe
//
//  Created by Xin Zou on 3/19/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class TrendingCell: FeedingCell {

    override func fecthVideos() {
        ApiService.sharedInstance.fetchTrendingFeeds { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
}
