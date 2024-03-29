//
//  SendCoinErrorVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/2/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class SendCoinErrorVC: UIViewController {

    var errorMessage: String!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        self.errorMessageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.errorMessageLabel.numberOfLines = 0
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.errorMessageLabel.text = errorMessage
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
