//
//  SendCoinSuccesVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/2/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import AVFoundation

class SendCoinSuccesVC: UIViewController {
    
    var amountSentInFiat: Double!
    var amountSentInCrypto: Double!
    var nameOfreciever: String!
    var phoneNumberOfReciever: String!
    
    var player: AVPlayer?
    
    @IBOutlet weak var amountSentFiatPlusCryptoLabel: UILabel!
    @IBOutlet weak var nameOfrecieverLabel: UILabel!
    @IBOutlet weak var phoneNumberOfRecieverLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameOfrecieverLabel.text = nameOfreciever
        phoneNumberOfRecieverLabel.text = phoneNumberOfReciever
        let x = String(format: "$ %.2f (%.7f BTC)", amountSentInFiat,amountSentInCrypto)
        amountSentFiatPlusCryptoLabel.text = x
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the top and bottom bar
        print("viewWillAppear")
        playBackgoundVideo()
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
        if let filePath = Bundle.main.path(forResource: "success2", ofType:"mp4") {
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
            print("gonna try to play success")
            player?.play()
        }
    }
    

}
