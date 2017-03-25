//
//  MenuBar.swift
//  youTubeMe
//
//  Created by Xin Zou on 1/31/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

let menuBarCellButtonColor = UIColor.rgb(r: 100, g: 20, b: 20)

class MenuBar : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .redYoutube // UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1)
        cv.dataSource = self // using self, then use lazy var
        cv.delegate = self
        return cv
    }()
    
    let cellId = "BarCell"
    let images : [UIImage] = [#imageLiteral(resourceName: "dogeWhite"), #imageLiteral(resourceName: "pawWhite256x256"), #imageLiteral(resourceName: "fireWhite1kx1k"), #imageLiteral(resourceName: "starWhite512x512")]
    
    // 1. init
    override init(frame: CGRect) {
        super.init(frame: frame)

        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        collectionView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        // set the default selection on menuBar[0]
        let idxPath = IndexPath(item: 0, section: 0) //NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: idxPath, animated: false, scrollPosition: .centeredVertically)
        
        setupHorizontalBar()
    }
    
    // 2. numberOfItemsInSection, cellForItemAt
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        //cell.backgroundColor = UIColor.yellow
        cell.imageView.image = images[indexPath.item].withRenderingMode(.alwaysTemplate)
        cell.tintColor = menuBarCellButtonColor // UIColor.rgb(r: 100, g: 20, b: 20)
        return cell
    }
    
    // 3. sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
    }
    // 4. minimumInteritemSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    var barLeftConstraint : NSLayoutConstraint?
    
    var homeController : HomeController?
    
    private func setupHorizontalBar(){
        let bar = UIView()
        bar.backgroundColor = .grayYoutube
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bar)
        barLeftConstraint = bar.leftAnchor.constraint(equalTo: self.leftAnchor)
        barLeftConstraint?.isActive = true
//        bar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        bar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: CGFloat(1) / CGFloat(images.count)).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    // when tapping on items:
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = frame.width * CGFloat(indexPath.row) / CGFloat(images.count)
//        self.barLeftConstraint?.constant = x
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
        
        // replaced by following:
        homeController?.scrollToPageAt(menuNum: indexPath.row)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



class MenuCell : BaseCollectionCell {
    
    let imageView : UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "doge_200x200").withRenderingMode(.alwaysTemplate) // for image.tintColor to show
        v.contentMode = .scaleAspectFit
        v.tintColor = menuBarCellButtonColor // UIColor.rgb(r: 100, g: 20, b: 20)
        return v
    }()
    
    override var isSelected: Bool { // isHighlighted did not work....
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : menuBarCellButtonColor
        }
    }
    
    override func setupCell() {
        //backgroundColor = .cyan
        addSubview(imageView)
        imageView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 12, topConstent: 12, rightConstent: 12, bottomConstent: 12, width: 0, height: 0)
    }
    
    
}

