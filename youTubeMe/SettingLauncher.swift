//
//  SettingLauncher.swift
//  youTubeMe
//
//  Created by Xin Zou on 3/15/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

enum SettingItem: String {
    case Setting = "Setting"
    case TermsPolicy = "Terms & privacy policy"
    case SendFeedback = "Send feedback"
    case Help = "Help"
    case SwitchAccount = "Switch account"
    case Cancel = "Cancel"
}

class MenuItem : NSObject {
    let name: SettingItem
    let icon: String
    
    init(_ icon: String = "", _ name:SettingItem) {
        self.icon = icon
        self.name = name
    }
}


class SettingLauncher : NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let blackBackground = UIView()

    let collectionMenuView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .white
//        v.layer.cornerRadius = 10
        
        return v
    }()
    
    
    let settingCellId = "settingCellId"
    let settingCellHeight : CGFloat = 50

    func showSettingMenu(){
        if let window = UIApplication.shared.keyWindow {
            blackBackground.isHidden = false
            blackBackground.frame = window.frame
            blackBackground.backgroundColor = UIColor.black
            blackBackground.alpha = 0
            blackBackground.isUserInteractionEnabled = true
            blackBackground.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(menuViewDismiss)))
            window.addSubview(blackBackground)
            
            let height : CGFloat = CGFloat(menuItems.count) * settingCellHeight
            collectionMenuView.frame = CGRect(x: 0, y: window.frame.maxY, width: window.frame.width, height: 0)
            window.addSubview(collectionMenuView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.blackBackground.alpha = 0.5
                self.collectionMenuView.frame = CGRect(x: 0, y: window.frame.maxY - height, width: window.frame.width, height: height)
            }, completion: nil)
        }
    }
    
    func menuViewDismiss(settingItem: MenuItem?){
        // dismiss by validated selection:
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.blackBackground.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionMenuView.frame = CGRect(x: 0, y: window.frame.maxY, width: window.frame.width, height: 0)
            }
        }) { (finish) in
            self.blackBackground.isHidden = true
            
            if settingItem?.name != nil && settingItem?.name != .Cancel {
                self.homeController?.showSettingControllerFor(item: settingItem!)
            }
        }
    }

    // setup menu items:
    var menuItems = [MenuItem]()
    let mSetting = MenuItem("⚙️", .Setting)
    let mTerms = MenuItem("🔐", .TermsPolicy)
    let mFeedBack = MenuItem("📩", .SendFeedback)
    let mHelp = MenuItem("🙋🏽", .Help)
    let mSwitchAccount = MenuItem("👤", .SwitchAccount)
    let mCancel = MenuItem("❌", .Cancel)

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionMenuView.dequeueReusableCell(withReuseIdentifier: settingCellId, for: indexPath) as! SettingCell
        let item = menuItems[indexPath.row]
        cell.iconLabel.text = item.icon
        cell.titleLeable.text = item.name.rawValue
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionMenuView.frame.width, height: settingCellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    var homeController : HomeController? // getting reference from HomeController.swift
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        menuViewDismiss(settingItem: item)
    }
    
    
    override init() {
        super.init()
        
        collectionMenuView.delegate = self
        collectionMenuView.dataSource = self

        collectionMenuView.register(SettingCell.self, forCellWithReuseIdentifier: settingCellId)
        
        menuItems = [mSetting, mTerms, mFeedBack, mHelp, mSwitchAccount, mCancel]
    }
    
}
