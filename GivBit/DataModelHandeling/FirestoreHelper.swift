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

    static var sharedInstnace = FirestoreHelper()
    let db = Firestore.firestore()
    
    override init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // MARK: - User
    // Gets the user info from the logged in user and other instances if any (must specify all sources of data)
    func saveLoggedInFirebaseUser(givbitUser gbUser: GBUser){
        let user = Auth.auth().currentUser
        if user != nil{
            // Add a new document with a generated ID
            var ref: DocumentReference? = db.collection("users").document(gbUser.uuid)
            ref!.setData(gbUser.dataAsDictionary()){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    
    // Checks if the user exists and if it exists it returns User with a true
    func fetchUserWithUUID(universalUserID uuid: String, completionHandler: @escaping (_ user: GBUser?, _ success: Bool) -> Void) {
        let query = db.collection("users").whereField("uid", isEqualTo: uuid)
        query.getDocuments { (querySnapshot, error) in
            if error != nil{
                completionHandler(nil, false)
            }else{
                // Only one document should exist
                for document in querySnapshot!.documents{
                    let user = GBUser()
                    user.fullName = document.data()["name"] as! String
                    user.phoneNumber = document.data()["phone_number"] as! String
                    completionHandler(user, true)
                }
                if querySnapshot!.documents.count <= 0{
                    completionHandler(nil, true)
                }
            }
        }
        //return (false, User())
    }
    // Checks if the user exists and if it exists it returns User with a true
    func updateUserContactOnFirebase(universalUserID uuid: String,contacts:[GBContact], completionHandler: @escaping (_ user: GBUser?, _ success: Bool) -> Void) {
        let query = db.collection("users").whereField("uid", isEqualTo: uuid)
        query.getDocuments { (querySnapshot, error) in
            if error != nil{
                completionHandler(nil, false)
            }else{
                // Only one document should exist
                for document in querySnapshot!.documents{
                    let user = GBUser()
                    user.fullName = document.data()["name"] as! String
                    user.phoneNumber = document.data()["phone_number"] as! String
                    completionHandler(user, true)
                }
                if querySnapshot!.documents.count <= 0{
                    completionHandler(nil, true)
                }
            }
        }
        //return (false, User())
    }
}
