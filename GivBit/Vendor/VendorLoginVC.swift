//
//  VendorLoginVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/21/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class VendorLoginVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // round the relevant views
        self.submitButton.layer.cornerRadius = 5
        self.backView.layer.cornerRadius = 5
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
