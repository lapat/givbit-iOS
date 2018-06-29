//
//  LoginVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/9/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import ChameleonFramework
import AVFoundation

class LoginVC: UIViewController {
        
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loginVC")
        // Do any additional setup after loading the view.
        
        // Added gradient background
       // self.view.backgroundColor = ColorsHelper.getLoginViewBackgroundGradientColor(rect: self.view.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the top and bottom bar
        print("viewWillAppear")
        playBackgoundVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func playBackgoundVideo() {
        if let filePath = Bundle.main.path(forResource: "1_7_moresubtle1", ofType:"mp4") {
            let filePathUrl = NSURL.fileURL(withPath: filePath)
            player = AVPlayer(url: filePathUrl)
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
                self.player?.seek(to: kCMTimeZero)
                self.player?.play()
            }
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil) { (_) in
                self.player?.seek(to: kCMTimeZero)
                self.player?.play()
            }
            self.view.layer.insertSublayer(playerLayer, at: 0)

            print("gonna try to play it")
            player?.play()
        }
    }
    


}
