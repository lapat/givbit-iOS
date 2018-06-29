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
    var amountToRequestFormatted: String! = "$00.00"
    var amountToRequestWithoutDot: String! = ""
    var amountToRequestInDouble: Double!
    
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
            fiatLabel.text = "$00.00"
            self.amountToRequestFormatted = fiatLabel.text
            self.amountToRequestWithoutDot = ""
            self.amountToRequestInDouble = 0
            return
        }
        let characterPressed = button.titleLabel?.text
        self.appendCharacterToAmount(char: characterPressed!)
        self.fiatLabel.text = self.amountToRequestFormatted
    }
    
    @IBAction func didTapOnCrossButton(button: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func appendCharacterToAmount(char: String){
        self.amountToRequestWithoutDot = self.amountToRequestWithoutDot + char
        self.amountToRequestFormatted = self.amountToRequestWithoutDot.currencyInputFormatting()
        
        let numNoCurrencySymbol = self.amountToRequestFormatted.replacingOccurrences(of: "$", with: "") as String
        let numNoCommaSymbol = numNoCurrencySymbol.replacingOccurrences(of: ",", with: "") as String
        
        self.amountToRequestInDouble = Double(numNoCommaSymbol)
        self.amountToRequestInDouble = Double(round(100 * self.amountToRequestInDouble)/100)
    }

}
