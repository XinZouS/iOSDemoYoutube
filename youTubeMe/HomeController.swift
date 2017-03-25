//
//  ViewController.swift
//  youTubeMe
//
//  Created by Xin Zou on 1/31/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    var videos : [Video] = {
//        let c1 = Channel(name: "Reponzel channel", profileImageName: "Reponzel02")
//        let v1 = Video(thumbnailImageName: "Reponzel_Disney", title: "Tangel - Reponzel in Disney, I will see this movie again maybe.", numberOfViews:1234566, channel: c1)
//
//        let c2 = Channel(name: "SnowQueen channel", profileImageName: "Elsa")
//        let v2 = Video(thumbnailImageName: "Elsa_Disny", title: "Frozen - Elsa and Anna in Disney", numberOfViews:987654321, channel: c2)
//        
//        return [v1, v2]
//    }()
    // replaced by code:90, for loading image online;
    
    let titles = ["Home", "Trending", "Subscriptions", "My Account"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.title = "youTubeMe" // reset title by new label:
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 36, height: 26))
        titleLabel.text = "  Home"
        //titleLabel.backgroundColor = .yellow
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        // setup navigationBar style
        navigationController?.navigationBar.isTranslucent = false // !!!!!!
        // remove shadow under bar
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // setup barItems for search and menu
        setupNavigationBarItems()
        
        setupCollectionView()
        setupMenuBar()
    }
    
    lazy var menuBar : MenuBar = {
        let m = MenuBar()
        m.homeController = self
        return m
    }()

    private func setupCollectionView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = .grayYoutube // UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
//        collectionView?.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 50, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        // a better way to set collection UIEdgeInsetsMake:
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        // 7. register as my VideoCell:
        // collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
        // collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(FeedingCell.self, forCellWithReuseIdentifier: feedingCellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.register(SubscriptCell.self, forCellWithReuseIdentifier: subscriptCellId)
        collectionView?.register(AccountCell.self, forCellWithReuseIdentifier: accountCellId)

        collectionView?.isPagingEnabled = true
    }
    private func setupMenuBar(){
        self.navigationController?.hidesBarsOnSwipe = true

        let redView = UIView()
        redView.backgroundColor = .redYoutube
        redView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(redView)
        redView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 50)
        
        view.addSubview(menuBar)
        menuBar.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 50)
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true // make bar not over flow to top;
        
    }
    
    private func setupNavigationBarItems(){
        let searchImg = #imageLiteral(resourceName: "searchIconWhite298x297").withRenderingMode(.alwaysOriginal)
        //let searchItem = UIBarButtonItem(image: searchImg, style: .plain, target: self, action: #selector(searchBarItemTapped))
        // above line can not adjust the size of image, so use following
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        searchBtn.setImage(searchImg, for: .normal)
        searchBtn.imageView?.contentMode = .scaleAspectFit
        searchBtn.addTarget(self, action: #selector(searchBarItemTapped), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: searchBtn)
        
        let menuImg = #imageLiteral(resourceName: "menuWhite512x512").withRenderingMode(.alwaysOriginal)
        //let menuItem = UIBarButtonItem(image: menuImg, style: .plain, target: self, action: #selector(menuBarItemTapped))
        let menuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        menuBtn.setImage(menuImg, for: .normal)
        menuBtn.imageView?.contentMode = .scaleAspectFit
        menuBtn.addTarget(self, action: #selector(menuBarItemTapped), for: .touchUpInside)
        let menuItem = UIBarButtonItem(customView: menuBtn)

        navigationItem.rightBarButtonItems = [menuItem, searchItem]
    }
    func searchBarItemTapped(){
        print("search")
    }
    
    lazy var settingLauncher : SettingLauncher = {
        let s = SettingLauncher()
        s.homeController = self
        return s
    }()
    
    func menuBarItemTapped(){
//        settingLauncher.homeController = self // pass reference for subview
        // replace above line by using lazy var at line 87 and setup at 89;
        settingLauncher.showSettingMenu()
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print(scrollView.contentOffset.x) // get position of scroll location;
        menuBar.barLeftConstraint?.constant = scrollView.contentOffset.x / 4
    }
    // set menuCollectionView item selected when dragging:
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // print(targetContentOffset.pointee.x / view.frame.width)
        let xRow = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(row: xRow, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
        setupNavigationTitle(num: xRow)
    }
    func scrollToPageAt(menuNum: Int) {
        let indexPath = IndexPath(item: menuNum, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        setupNavigationTitle(num: menuNum)
    }
    private func setupNavigationTitle(num: Int){
        guard num < titles.count else { return }
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[num])"
        }
    }
    
    
    
    // for items in SettingMenu:
    func showSettingControllerFor(item: MenuItem){
        let settingController = UIViewController()
        settingController.title = item.name.rawValue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white] // !!!
        navigationController?.view.backgroundColor = .white
        navigationController?.pushViewController(settingController, animated: true)
    }
    func showSwithcAccountController(){
        print("make a new login controller for this item...")
    }
    

    
    
    func setupChannelImages(){
        
    }
    
    
    let feedingCellId = "CellId"
    let trendingCellId = "TrendingCellId"
    let subscriptCellId = "SubscriptCellId"
    let accountCellId = "AccountCellId"
    
    //=== One session of vertical collection view : for FeedingCell ================
//    // 1. setup collectionView:
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        //if let count = videos?.count {
//        //    return count
//        //}
//        //return 0
//        // replace above code by:
//        return videos?.count ?? 0  // return videos?.count != nil ? videos.count : 0
//    }
//    // 2. setup Cells: cellForItemAt
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
//        //cell.backgroundColor = .green
//        if indexPath.item < (videos?.count)! {
//            cell.video = videos![indexPath.item]
//        }
//        return cell
//    }
//    // 3. cell size cellSize: collectionViewSizeForItemAt
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let h = (view.frame.width - 10 - 10) / (16/9)
//        return CGSize(width: view.frame.width, height: h + (20 + 66))
//    }
//    // and minimumLineSpacingForSectionAt
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }

    //=== 4 sessions of horizontal collection view =================================
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBar.images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellId : String?
        switch indexPath.item {
        case 0:
            cellId = feedingCellId
        case 1:
            cellId = trendingCellId
        case 2:
            cellId = subscriptCellId
        case 3:
            cellId = accountCellId
        default:
            cellId = feedingCellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId!, for: indexPath) as! FeedingCell
        
//        let color: [UIColor] = [UIColor.green, UIColor.cyan, UIColor.purple, UIColor.blue]
//        cell.backgroundColor = color[indexPath.item]
        cell.backgroundColor = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        let h = self.view.frame.height
        return CGSize(width: w, height: h - 50)
    }
    // do this in line 56, when setup layout of collectinView;
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }

}


