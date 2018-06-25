//
//  VendorCreateInvoiceVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/22/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class VendorCreateInvoiceVC: UIViewController {

    @IBOutlet weak var fiatLabel: UILabel!
    @IBOutlet weak var genQRCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.genQRCodeButton.layer.cornerRadius = 5
        
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
    
    //MARK: - Actions
    @IBAction func didTapOnGenerateQRCodeButton(button: UIButton){
        
    }
    
    @IBAction func didTapOnNumpadButton(button: UIButton){
        if button.titleLabel?.text == "C"{
            fiatLabel.text = "00.00"
        }
    }
    
    @IBAction func didTapOnCrossButton(button: UIButton){
        self.dismiss(animated: true, completion: nil)
    }

}
