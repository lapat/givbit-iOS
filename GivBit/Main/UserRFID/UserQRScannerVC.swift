//
//  UserQRScannerVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/25/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import SVProgressHUD

class UserQRScannerVC: UIViewController {
    
    var currencyAmount: Double! = 0.0
    var btcAmount: Double! = 0.0
    var companyName: String! = ""
    var givBitTransactionCode: String! = ""
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // hide the top view
        self.navigationController?.navigationBar.isHidden = true
        self.scanAction(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.scanAction(self)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "approveInvoiceSegue"{
            let destinationVC = segue.destination as! ConfirmPaymentVC
            print("givBitTransactionCode:"+self.givBitTransactionCode)
            destinationVC.givBitTransactionCode = self.givBitTransactionCode
            destinationVC.currencyAmount = self.currencyAmount
            destinationVC.btcAmountConfrim = self.btcAmount
            destinationVC.companyName = self.companyName
            
            let currencyAmountString:String = String(format:"%.2f", currencyAmount)
            let btcAmountString:String = String(format:"%.8f", btcAmount)
            print("CompanyName:"+companyName)
            DispatchQueue.main.async {
                destinationVC.payWhoLabel.text = "Pay "+self.companyName;
                destinationVC.amountToPay.text = "$" + currencyAmountString + " in BTC";
                destinationVC.btcAmount.text = btcAmountString + " BTC";
            }
            
        }
    }
    
    
    @IBAction func scanAction(_ sender: AnyObject) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print("got QR Code - result.value:")
            let invoiceId = result?.value
            self.givBitTransactionCode = invoiceId
            if nil == invoiceId {
                return
            }
            print(invoiceId)
            SVProgressHUD.show()
            
            FirebaseHelper.getInvoiceData(invoiceId: invoiceId!) { (currencyAmount, btcAmount, companyName, status, error) in
                SVProgressHUD.dismiss()
                self.currencyAmount = currencyAmount
                self.btcAmount = btcAmount
                self.companyName = companyName
                print("companyName:"+companyName)
                if error == nil{
                    if (status == "CREATED"){
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "approveInvoiceSegue", sender: self)
                        }
                    }else  if (status == "PAID"){
                        AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "This invoice has already been paid.", andTitle: "Invoice Paid")
                        //TO DO - GO BACK TO CONTACTS PAGE?
                    }else  if (status == "CANCELLED"){
                        AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "This invoice was canceled.", andTitle: "Invoice Cancelled")
                        //TO DO - GO BACK TO CONTACTS PAGE
                    }
                }else{
                    print("Error getInvoiceData function \(String(describing: error?.localizedDescription))")
                    
                }
                
            }
            
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
}

extension UserQRScannerVC: QRCodeReaderViewControllerDelegate{
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}


class qrScanningView: UIView, QRCodeReaderDisplayable{
    func setNeedsUpdateOrientation() {
        
    }
    
    func setupComponents(showCancelButton: Bool, showSwitchCameraButton: Bool, showTorchButton: Bool, showOverlayView: Bool, reader: QRCodeReader?) {
        
    }
    
    let cameraView: UIView            = UIView()
    let cancelButton: UIButton?       = UIButton()
    let switchCameraButton: UIButton? = SwitchCameraButton()
    let toggleTorchButton: UIButton?  = ToggleTorchButton()
    var overlayView: UIView?          = UIView()
    
    func setupComponents(showCancelButton: Bool, showSwitchCameraButton: Bool, showTorchButton: Bool, showOverlayView: Bool) {
        // addSubviews
        // setup constraints
        // etc.
    }
}

