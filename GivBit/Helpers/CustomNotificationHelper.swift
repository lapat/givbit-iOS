//
//  CustomNotificationClass.swift
//  GivBit
//
//  Created by Tallal Javed on 7/17/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class CustomNotificationHelper: NSObject {
    
    static let sharedInstance = CustomNotificationHelper()
    var notificationHeight: CGFloat = 50
    
    // adds notiicatin at the end of view
    func addNotificationAtBottomForCoinbaseRelinking(inViewController viewController: UIViewController){
        let view = BottomNotificationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //let parentFrame = viewController.view.frame
        //view.frame = CGRect(x: 0, y: 100, width: parentFrame.width, height: notificationHeight)
        
        viewController.view.addSubview(view)
        self.addBottomConstraintsWithSafeAreForNotification(inViewController: viewController, andNotificationView: view)
        viewController.view.layoutSubviews()
        
        // add subview with animation
        UIView.animate(withDuration: 0.3, animations: {
            // add the constraints
            NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 50.0)])
            viewController.view.layoutSubviews()
        }, completion: nil)
    }
    
    // adjusts the view for tabbar controller
    private func addBottomConstraintsWithSafeAreForNotification(inViewController vc: UIViewController, andNotificationView view: UIView){
        _ = vc.view.layoutMargins
        //let safeAreaGuide = vc.view.safeAreaLayoutGuide
        if #available(iOS 11.0, *) {
            let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: vc.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
            
            let safeAreaGuide = vc.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([safeAreaGuide.bottomAnchor.constraintEqualToSystemSpacingBelow(view.bottomAnchor, multiplier: 0.0),
                view.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
                view.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
                view.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor)])
            NSLayoutConstraint.activate([bottomConstraint])
        } else {
            // Fallback on earlier versions
        }
        
        
        // set the new frame with respect to the safe area instes
        
    }

}
