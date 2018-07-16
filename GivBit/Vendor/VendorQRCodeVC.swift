//
//  QRCodeVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/22/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import QRCode

class VendorQRCodeVC: UIViewController {
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var vendorNameLabel: UILabel!
    @IBOutlet weak var vendorAmountRequestedLabel: UILabel!
    @IBOutlet weak var btcAmountLabel: UILabel!
    var btcAmountString: String! = ""
    var givbitTransactionCode: String! = "Not set"
    var vendorName: String!
    var transactionAmount: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set the gradient view for qrcode
        
        let color1 = ColorsHelper.generalBlueColor
        let color2 = UIColor.flatWatermelon
        let gradientColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [color2, color1!])
        //self.view.backgroundColor = gradientColor
        
        self.generateQRCode()
        
        // hide the top view and bottom view
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        // populate vendor info
        vendorNameLabel.text = vendorName
        vendorAmountRequestedLabel.text = transactionAmount
        self.btcAmountLabel.text = self.btcAmountString + " BTC"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedInvoiceNoticationFunction(_:)), name: NSNotification.Name(rawValue: "rececivedInvoiceNotification"), object: nil)

    }

    
    //Hmmmm...looks like sometimes we dont get the notification, maybe need to poll too?
    @objc func receivedInvoiceNoticationFunction(_ notification: NSNotification) {
        print("Got Notification")
        if let invoiceId = notification.userInfo?["invoiceId"] as? String {
            let invoiceStatus = notification.userInfo?["invoiceStatus"] as? String
            //TO DO - add error handling with vendor
            print("Got Invoice PAID VENDOR NOTIFICATION - Invoice ID:"+invoiceId+" invoiceStatus:"+invoiceStatus!)
            // do something with your image
            if (invoiceId == givbitTransactionCode){
                print("matches current invoiceID - going to next VC")
                if (invoiceStatus == "PAID"){
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showSuccessVendorPaidSegue", sender: self)
                    }
                }else{
                    //TO DO - add error handling MESSAGE with vendor
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showErrorVendorSegue", sender: self)
                    }
                }
            }else{
                print("Got notification - but does NOT match current invoiceID")
            }
            //Next stuff is for testing to test notifications on any vendor screen.
            //let invoiceStatusTest = notification.userInfo?["invoiceStatus"] as? String
            //TO DO - add error handling with vendor
            //print(" invoiceStatus:"+invoiceStatusTest!)
            //DispatchQueue.main.async {
            //   self.performSegue(withIdentifier: "showErrorVendorSegue", sender: self)
            //}
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        //To do - Maybe move this thing below to the storyboard?
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "purpleBlueBackground")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateQRCode(){
        if (givbitTransactionCode == "Not set"){
            AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "There was an error with your invoice, please contact support or try again.", andTitle: "Sorry")
            return;
        }
        print("givbitTransactionCode");
        print(givbitTransactionCode);
        var qrCode = QRCode(givbitTransactionCode);
        qrCode?.size = qrCodeImageView.frame.size
        qrCode?.backgroundColor = CIColor(color: ColorsHelper.whiteColor!)
        qrCodeImageView.image = qrCode?.image
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSuccessVendorPaidSegue"{
            let destinationVC = segue.destination as! VendorGotPaidSuccessVC
            destinationVC.btcAmountString = self.btcAmountString
            destinationVC.currencyAmountString = self.transactionAmount
        }
    }
    
    
    // MAKR: - Actions
    @IBAction func didTapOnBackButton(button: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
