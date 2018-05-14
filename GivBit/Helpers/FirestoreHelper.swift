//
//  FirestoreHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 5/10/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase

class FirestoreHelper: NSObject {

    static let sharedInstnace = FirestoreHelper()
    static let db = Firestore.firestore()
    
    
    override init() {
        
    }
    
    // MARK: - User
    func saveLoggedInFirebaseUser(){
        let user = Auth.auth().currentUser
        if user != nil{
            
        }
    }
}
