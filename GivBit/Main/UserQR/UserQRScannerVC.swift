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
        if segue.identifier == "confirmInvoiceSegue"{
            /*
            let destinationVC = segue.destination as! confirmInvoiceVC
            destinationVC.givbitTransactionCode = givBitTransactionCode
            destinationVC.currencyAmount = self.currencyAmount
            destinationVC.btcAmount = self.btcAmount
            destinationVC.companyName = self.companyName
            */
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

            print(invoiceId)
            SVProgressHUD.show()
            
            FirebaseHelper.getInvoiceData(invoiceId: invoiceId!) { (currencyAmount, btcAmount, companyName, error) in
                SVProgressHUD.dismiss()
                self.currencyAmount = currencyAmount
                self.btcAmount = btcAmount
                self.companyName = companyName
                //print("currencyAmount:"+currencyAmount+"btcAmount:"+btcAmount+" companyName:"+companyName)
                if error == nil{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "approveInvoiceSegue", sender: self)
                    }
                }else{
                    // process the error
                    DispatchQueue.main.async {
                        print("error gettingInvoiceData")
                        //self.performSegue(withIdentifier: "showQRCodeSegue", sender: self)
                    }
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
