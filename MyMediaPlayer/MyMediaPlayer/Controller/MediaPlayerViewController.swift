//
//  MediaPlayerViewController.swift
//  MyMediaPlayer
//
//  Created by Ameer Shaikh on 05/07/2020.
//  Copyright © 2020 SAED. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import RappleProgressHUD


class MediaPlayerViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var audioDetailsTV: UITextView!
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var mediaTitle: UILabel!
    @IBOutlet weak var playPuseButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var tractDuration: UILabel!
    @IBOutlet weak var tractCompletedTime: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var maxVolumeButton: UIButton!
    @IBOutlet weak var trackProgressView: UISlider!
    public var position: Int = 0
    public var mediaArray: MediaList = []
    var player: AVAudioPlayer?
    var player1 : AVPlayer?
    var observer : Any?


    override func viewDidLoad() {
        super.viewDidLoad()
        _initialiseAudioPlayer()
        // Do any additional setup after loading the view.
        RappleActivityIndicatorView.startAnimating()
        
        playPuseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .selected)
        
        playPuseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)

        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(playerItemDidReachEnd),
                                                                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                                object: nil)
        }

//        @objc func playerItemDidReadyToPlay() {
//            //if let _ = notification.object as? AVPlayerItem {
//            // player is ready to play now!!
//           // self.activityIndicator.stopAnimating()
//            //RappleActivityIndicatorView.stopAnimation()
//        }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           RappleActivityIndicatorView.stopAnimation()

       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let player1 = player1 {
            player1.pause()
            player1.replaceCurrentItem(with: nil)
           // player1.cancelPendingPrerolls()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let observer = observer {
            player1?.removeTimeObserver(observer)
            self.observer = nil
        }
        player1?.pause()
    }
    
   // ### MARK  : Audio Player Services
    @objc func playerItemDidReachEnd() {
        print("Track Finished!")
        nextClicked()
    }
    func startPlayer(url:URL) {
       // self.activityIndicator.startAnimating()
        self.trackProgressView.value = 0
        if let observer = self.observer {
                       player1?.removeTimeObserver(observer)
                       self.observer = nil
                   }

        do{
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            player1 = try AVPlayer(url: url)
            
            guard let player = player1 else { return }
            player.play()
           // player.removeTimeObserver()
          //  activityIndicator.stopAnimating()
            
           
            
            self.observer = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil) { time in
                
                if(player.currentItem != nil) {
                    
                    if(time.value == 0) {
                        RappleActivityIndicatorView.stopAnimation()
                        self.activityIndicator.stopAnimating()
                    }
                    
                    let duration = CMTimeGetSeconds(player.currentItem!.duration)
                    
                    if  !duration.isNaN  {
                        self.tractDuration.text = "\(Int(duration/60)):\(Int(duration.truncatingRemainder(dividingBy: 60)))"
                        self.trackProgressView.value = Float((CMTimeGetSeconds(time) / duration))
                                       //print(duration)
                                        
                        let completedDuration = CMTimeGetSeconds((player.currentItem?.currentTime())!)
                        self.tractCompletedTime.text = "\(Int(completedDuration/60)):\(Int(completedDuration.truncatingRemainder(dividingBy: 60)))"
                    }
                    
                }
            }
         } catch let error {
               print(error.localizedDescription)
                  }
    }
    
    func _initialiseAudioPlayer() {
        RappleActivityIndicatorView.startAnimating()

        self.tractCompletedTime.text = "--:--"
        self.tractDuration.text = "--:--"
        let media = mediaArray[position]
        let urlString = media.url

        let url = URL(string: urlString)
        print("the url = \(url!)")
        startPlayer(url: url!)
        
        // Set up rest of UI
        let imageURL = URL(string: media.logoMin)
        self.previewImage.sd_imageIndicator?.startAnimatingIndicator()
        self.previewImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.previewImage.sd_setImage(with: imageURL)
        
        self.mediaTitle.text = media.audioname
        self.audioDetailsTV.text = media.booksynopsysenglish
        
        
        prevButton.isEnabled = true
        nextButton.isEnabled = true
        if (position == 0) {
            prevButton.isEnabled = false
        }
        else if (position == (mediaArray.count - 1)) {
            nextButton.isEnabled = false
        }
    }
        
    @IBAction func volumeSliderUpdated(_ sender: UISlider) {
        player1?.volume = sender.value
    }
        
    @IBAction func prevClicked() {
            if position > 0 {
                position = position - 1
    //            player?.stop()
                player1?.pause()
                _initialiseAudioPlayer()
            }
    }
        
    @IBAction func nextClicked() {
        if position < (mediaArray.count - 1) {
                position = position + 1
               // player?.stop()
                player1?.pause()
                _initialiseAudioPlayer()
        }
    }
        
    @IBAction func playPauseClicked(_ sender: UIButton) {
            
            if(player1?.timeControlStatus == .playing) {
                player1?.pause()
                playPuseButton.isSelected = true
                playPuseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            }
            else {
                player1?.play()
                playPuseButton.isSelected = false
                playPuseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)

            }
        }
    
    @IBAction func trackProgressChanged(_ slider: UISlider) {
//            player1?.seek(to: CMTime(seconds: Double(slider.value), preferredTimescale: 1) )
            if let duration = player1?.currentItem?.duration {
                let totalSecond = CMTimeGetSeconds(duration)
                
                let value = Float64(slider.value) * totalSecond
                
                if(value != Double.nan){
                    let seekTime = CMTime(value: Int64(value), timescale: 1)
                    player1?.seek(to: seekTime, completionHandler: { (completedSeek) in
                        // later
                    })
                }
            }
        }
    
    @IBAction func muteClicked(_ sender: UIButton) {
        print("Mute Clicked")
        player1?.volume = 0.0
        volumeSlider.value = 0.0
        //player1?.pause()
    }
    @IBAction func maxVolumeClicked(_ sender: UIButton) {
        player1?.volume = 1.0
        volumeSlider.value = 1.0

        print("Max Clicked")
    }
    
    // Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
