//
//  SettingCell.swift
//  youTubeMe
//
//  Created by Xin Zou on 3/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class SettingCell : BaseCollectionCell {
    
    override var isHighlighted: Bool {
        didSet {
            // print(isHighlighted)
            self.backgroundColor  = isHighlighted ? .gray : .white
            titleLeable.textColor = isHighlighted ? .white : .gray
        }
    }

    
    let iconLabel : UILabel = {
        let v = UILabel()
        v.backgroundColor = .clear
        v.font = UIFont(name: "System", size: 26)
        v.textAlignment = .center
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let titleLeable : UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textColor = UIColor.gray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override func setupCell() {
        super.setupCell()
        
        addSubview(iconLabel)
        iconLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: bottomAnchor, leftConstent: 20, topConstent: 10, rightConstent: 0, bottomConstent: 10, width: 30, height: 0)

        addSubview(titleLeable)
        titleLeable.addConstraints(left: iconLabel.rightAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 10, topConstent: 10, rightConstent: 10, bottomConstent: 10, width: 0, height: 0)
        
        backgroundColor = .white
    }
    
    
}

