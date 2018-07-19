//
//  CustomNotificationClass.swift
//  GivBit
//
//  Created by Tallal Javed on 7/17/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class CustomNotificationManager: NSObject {
    
    static let sharedInstance = CustomNotificationManager()
    var notificationHeight: CGFloat = 50
    
    // adds notiicatin at the end of view
    func addNotificationAtBottomForCoinbaseRelinking(inViewController viewController: UIViewController){
        // check if view has a notification already?
        // if yes then dont show a new animation
        if checkIfViewControllerHasBottomNotification(viewController: viewController){
            return
        }
        
        let view = BottomNotificationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //let parentFrame = viewController.view.frame
        //view.frame = CGRect(x: 0, y: 100, width: parentFrame.width, height: notificationHeight)
        
        viewController.view.addSubview(view)
        self.addBottomConstraintsWithSafeAreForNotification(inViewController: viewController, andNotificationView: view)
        viewController.view.layoutSubviews()
        
        // Add the gesture recognizer
        let swipGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipDownOnNotification(sender:)))
        swipGesture.direction = .down
        view.addGestureRecognizer(swipGesture)
        
        // Set the lable and explaination for the coinbase notification
        view.set(label: "Coinbase Needs Relinking", andExplaination: "We need coinbase, to process recieving and sending of payments", buttonLabel: "Relink")
        
        // add the button action
        view.addButtonAction(target: self, action: #selector(didTapOnReLinkCoinbaseButton(sender:)))
        
        // add subview with animation
        UIView.animate(withDuration: 0.3, animations: {
            // add the constraints
            view.removeConstraint(view.heightConstraint)
            NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 50.0)])
            viewController.view.layoutSubviews()
        }, completion: nil)
    }
    
    func removeCoinbaseNotificationFromView(view: UIView){
        for view in view.subviews{
            if type(of: view) == type(of: BottomNotificationView()){
                view.removeFromSuperview()
            }
        }
    }
    
    // MARK: - UTILITY
    private func checkIfViewControllerHasBottomNotification(viewController vc: UIViewController)-> Bool{
        for view in vc.view.subviews{
            if type(of: view) == type(of: BottomNotificationView()){
                return true
            }
        }
        return false
    }
    
    // MARK:- Actions
    @objc private func didSwipDownOnNotification(sender: UISwipeGestureRecognizer){
        let view = sender.view as! BottomNotificationView
        UIView.animate(withDuration: 0.3, animations: {
            view.removeConstraint(view.heightConstraint)
            NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 0.0)])
            view.superview?.layoutIfNeeded()
        }) { (b) in
            view.removeFromSuperview()
        }
    }
    
    @objc private func didTapOnReLinkCoinbaseButton(sender: UIButton){
        // transition to the settings view.
        let vc = sender.parentContainerViewController()
        DispatchQueue.main.async {
            vc?.performSegue(withIdentifier: "settingSegue", sender: self)
        }
    }
    
    // MARK:- Constraints
    // adjusts the view for being shown at the bottom
    private func addBottomConstraintsWithSafeAreForNotification(inViewController vc: UIViewController, andNotificationView view: BottomNotificationView){
        _ = vc.view.layoutMargins
        //let safeAreaGuide = vc.view.safeAreaLayoutGuide
        if #available(iOS 11.0, *) {
            let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: vc.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
            
            let safeAreaGuide = vc.view.safeAreaLayoutGuide
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: 0.0)
            view.heightConstraint = heightConstraint
            NSLayoutConstraint.activate([safeAreaGuide.bottomAnchor.constraintEqualToSystemSpacingBelow(view.bottomAnchor, multiplier: 0.0),
                heightConstraint,
                view.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
                view.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor)])
            NSLayoutConstraint.activate([bottomConstraint])
        } else {
            // Fallback on earlier versions
        }
        
        
        // set the new frame with respect to the safe area instes
        
    }

}
