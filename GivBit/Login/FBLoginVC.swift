//
//  LoginVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/7/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class FBLoginVC: LoginVC {

    // MARK: - Variables
    @IBOutlet var fbLoginBut: UIButton!
    var loginButton: FBSDKLoginButton!
    
    // MARK: - UI Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add login with fb button
        loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.frame.origin = fbLoginBut.frame.origin
        self.view.addSubview(loginButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Actions
    

}

extension FBLoginVC: FBSDKLoginButtonDelegate {
    // Meh read the function name and its enough :)
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }else{
            // Successfully logged in
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            if Auth.auth().currentUser != nil{
                // User already signed in... add this method to users account
                Auth.auth().currentUser?.link(with: credential, completion: { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }else{
                        // User is signed in
                        print(user?.email ?? "")
                        self.performSegue(withIdentifier: "EditProfile-Segue", sender: self)
                    }
                })
            }else{
                Auth.auth().signIn(with: credential) { (user, error) in
                    if error != nil {
                        // ...
                        return
                    }else{
                        // User is signed in
                        print(user?.email ?? "")
                        self.performSegue(withIdentifier: "EditProfile-Segue", sender: self)
                    }
                }
            }
        }
    }
    
    // explainatory enough :D...
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}
