//
//  VideoLuncherController.swift
//  youTubeMe
//
//  Created by Xin Zou on 3/23/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import AVFoundation


class VideoPlayerView : UIView {
    
    var player : AVPlayer?
    var isVideoPlaying = false
    
    let activityIndicator : UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.startAnimating()
        v.hidesWhenStopped = true
        return v
    }()
    
    let controlContainerView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.alpha = 0.3
        return v
    }()
    
    let pausePlayButton : UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "playbutton"), for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(handlePausePlay), for: .touchUpInside)
        return b
    }()
    
    let videoLengthLabel: UILabel = {
        let l = UILabel()
        l.text = "00:00"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .white
        l.textAlignment = .right
        //l.backgroundColor = .green
        return l
    }()
    
    let videoPlayTimeLabel: UILabel = {
        let l = UILabel()
        l.text = "00:00"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .white
        l.textAlignment = .left
        return l
    }()
    
    lazy var videoSlider : UISlider = {
        let s = UISlider()
        s.minimumTrackTintColor = .red
        s.maximumTrackTintColor = .white
        s.setThumbImage(#imageLiteral(resourceName: "redDot15x15"), for: .normal)
        s.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return s
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = .black

        setupPlayerView()
        
        setupGradientLayer()
        
        addSubview(controlContainerView)
        controlContainerView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(videoLengthLabel)
        videoLengthLabel.addConstraints(left: nil, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 6, bottomConstent: 3, width: 45, height: 15)
        addSubview(videoPlayTimeLabel)
        videoPlayTimeLabel.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: bottomAnchor, leftConstent: 6, topConstent: 0, rightConstent: 0, bottomConstent: 3, width: 45, height: 15)
        addSubview(videoSlider)
        videoSlider.addConstraints(left: nil, top: nil, right: nil, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 3, width: 0, height: 15)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: 0).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: videoPlayTimeLabel.rightAnchor, constant: 0).isActive = true
        
    }
    
    // auto added in after I add override init()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlayerView(){
        let videoUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/chatdemo-4eb7c.appspot.com/o/message_video%2FPenny_E986D9AA-CE03-4727-8422-6ECA092B05CB.mov?alt=media&token=6dfdaeb4-a9b0-4045-8731-227d5f7581ce")
        player = AVPlayer(url: videoUrl!)
        let playerLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(playerLayer) // so player can display
        playerLayer.frame = self.frame
        
        // for hiding containerView after video loaded:
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        player?.play()
        isVideoPlaying = true
        
        // track player progress
        let interval = CMTime(value: 1, timescale: 2) // at 1 second, track each 2 sec;
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (cmTimeCurrent) in
            //print(cmTimeCurrent) // get current playing time position;
            let sec = CMTimeGetSeconds(cmTimeCurrent)
            let secText = String(format: "%02d", Int(sec) % 60)
            let minText = String(format: "%02d", Int(sec) / 60)
            self.videoPlayTimeLabel.text = "\(minText):\(secText)"
            
            // update slider:
            let duration = self.player?.currentItem?.duration
            let durationSec = CMTimeGetSeconds(duration!)
            let currPosition = Float(sec / durationSec)
            self.videoSlider.setValue(currPosition, animated: true)
        })

    }
    
    private func setupGradientLayer(){ // gradient color at bottom for slider more clear;
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor] // blue--->red gradient
        gradientLayer.locations = [0.5, 1.0] // upperline, bottom line, scaled to self.view; 0.7,1.2 will move it downwards;
        controlContainerView.layer.addSublayer(gradientLayer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicator.stopAnimating()
            controlContainerView.backgroundColor = .clear
            pausePlayButton.alpha = 0
            isVideoPlaying = true
            
            // setup playTimeLabels:
            if let duration = player?.currentItem?.duration {
                let sec = CMTimeGetSeconds(duration)
                let secText = Int(sec) % 60
                //let minText = Int(sec) / 60 // get 0:00, use the formater:
                let minText = String(format: "%02d", Int(sec) / 60) // 00:00
                videoLengthLabel.text = "\(minText):\(secText)"
            
                videoPlayTimeLabel.text = "00:00"
            }
        }
    }
    
    func handleSliderChange(){
        //print(videoSlider.value) // 0--1
        
        guard let duration = player?.currentItem?.duration else { return }
        let totalSeconds = CMTimeGetSeconds(duration)
        let targetSecInVideo = Float64(videoSlider.value) * totalSeconds
        //  seekTime = CMTime(value: targetValueInVideo, timescale: 1 as seconds)
        let seekTime = CMTime(value: Int64(targetSecInVideo), timescale: 1)
        
        player?.seek(to: seekTime, completionHandler: { (completSeek) in
            //
        })
    }
    

    func handlePausePlay(){
        print("==============")
        if isVideoPlaying {
            player?.pause()
            pausePlayButton.setImage(#imageLiteral(resourceName: "playbutton"), for: .normal)
            pausePlayButton.alpha = 1
        }else{
            player?.play()
            pausePlayButton.setImage(#imageLiteral(resourceName: "pausebutton"), for: .normal)
            pausePlayButton.alpha = 0
        }
        isVideoPlaying = !isVideoPlaying
    }
    
    
}



class VideoLuncher: NSObject { // ******* should I make it as an NSObject? or ViewController?
    
    
    
    func showVideoPlayer(){ // with animation
        if let keyWindow = UIApplication.shared.keyWindow {
            let windowFrame = keyWindow.frame
            
            // add background view for self:
            let margin : CGFloat = 100
            let backGroundView = UIView(frame: CGRect(x: windowFrame.width - margin, y: windowFrame.height - margin, width: margin, height: margin))
            backGroundView.backgroundColor = .white
            backGroundView.alpha = 0.5
            keyWindow.addSubview(backGroundView)
            
            // add video player view:
            let videoHight = (windowFrame.width) * 9 / 16
            let videoFrame = CGRect(x: 0, y: 0, width: windowFrame.width, height: videoHight)
            let videoView = VideoPlayerView(frame: videoFrame)
            backGroundView.addSubview(videoView)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                backGroundView.frame = windowFrame
                backGroundView.alpha = 1
            }, completion: { (success) in
                // hide statusBar:
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
            
        }
    }
    
}
