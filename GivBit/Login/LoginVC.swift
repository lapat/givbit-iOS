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
        //playBackgoundVideo()
        ImageHelper.sharedInstance.playBackgoundVideo(aView : self.view , videoName :  "1_7_moresubtle1")
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


}
