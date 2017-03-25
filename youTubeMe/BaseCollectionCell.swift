//
//  BaseCollectionCell.swift
//  youTubeMe
//
//  Created by Xin Zou on 3/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class BaseCollectionCell : UICollectionViewCell {
    
    // 5. init cell:
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        
    }
    
    func setupCell(){ }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



