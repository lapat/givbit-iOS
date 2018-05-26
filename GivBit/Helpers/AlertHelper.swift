//
//  AlerHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 5/25/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    static let sharedInstance = AlertHelper()
    
    func showAlert(inViewController controller: UIViewController, withDescription description: String, andTitle title: String){
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertControllerStyle.alert)
        let okButton =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (action) in
            controller.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okButton)
        controller.present(alert, animated: true, completion: nil)
    }
    
    // basic alert with completion handler
    func showAlert(inViewController controller: UIViewController, withDescription description: String, andTitle title: String, completionHandler: @escaping ()->Void){
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertControllerStyle.alert)
        let okButton =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (action) in
            controller.dismiss(animated: true, completion: nil)
            completionHandler()
        }
        alert.addAction(okButton)
        controller.present(alert, animated: true, completion: nil)
    }
    
    // show a alert with completion handler.
}
