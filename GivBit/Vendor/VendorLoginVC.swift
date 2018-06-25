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
        
        // top bar
        self.navigationController?.navigationBar.isHidden = true
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

    // MARK: - Actions
    @IBAction func didTapOnCrossButton(){
        self.dismiss(animated: true) {
            
        }
    }
}

extension VendorLoginVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "1")
            return cell!
        }
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "2")
            return cell!
        }
        if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "3")
            return cell!
        }
        
        return UITableViewCell()
    }
}
