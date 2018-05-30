//
//  FirestoreHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 5/10/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase
import Contacts

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
            let ref: DocumentReference? = db.collection("users").document(gbUser.uuid)
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
    func getUserWithUUID(universalUserID uuid: String, completionHandler: @escaping (_ user: GBUser?, _ success: Bool) -> Void) {
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
    
    //MARK: Transactions
    func getTransactionsForUser(uuid: String, completionHandler: @escaping (_ transactions: [GBTransaction], _ success: Bool) -> Void){
        let query = db.collection("transactions").whereField("sender_uid", isEqualTo: uuid)
        query.getDocuments { (querySnapShot, error) in
            if error != nil{
                // Error occured
                completionHandler([GBTransaction](), false)
            }else{
                var transactions = [GBTransaction]()
                for document in querySnapShot!.documents{
                    let transaction = GBTransaction()
                    transaction.cryptoAmount = "9.00sdf1" // document.data()["btc_amount"] as! String
                    transaction.coinbaseItemID = document.data()["coinbase_idem_id"] as! String
                    transaction.date = document.data()["date"] as! Int
                    transaction.pending = document.data()["pending"] as! Bool
                    transaction.recieverPhoneNumber = document.data()["receiver_phone_number"] as! String
                    transaction.recieverUID = document.data()["receiver_uid"] as! String
                    transaction.senderUID = document.data()["sender_uid"] as! String
                    transactions.append(transaction)
                }
                completionHandler(transactions, true)
            }
        }
    }
    
    func updateCoinbaseidOnCoinbaseWithUUID(universalUserID uuid: String,accessToken : String,refreashToken : String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let tokens = ["coinbase_refresh_token": refreashToken, "coinbase_token": accessToken]
        
        let user = Auth.auth().currentUser
        if user != nil{
            // Add a new document with a generated ID
            let ref: DocumentReference? = db.collection("users").document(uuid)
            ref!.updateData(tokens){ err in
                if var err = err {
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            }
        }
      
        //return (false, User())
    }
    // Upload user contacts on server
    func updateUserContactOnFirebase(universalUserID uuid: String, completionHandler: @escaping ( _ success: Bool) -> Void) {
        ContactsManager.sharedInstance.convertToDictionery()
        let Contacts = ["contacts": ContactsManager.sharedInstance.convertedContacts]
        
        let user = Auth.auth().currentUser
        if user != nil{
            // Add a new document with a generated ID
            let ref: DocumentReference? = db.collection("users").document(uuid)
            ref!.updateData(Contacts){ err in
                if err != nil {
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            }
        }
        
        else  {
            completionHandler( false)
        }
    }
    
    // MARK: - Crypto Prices
    func getBTCPriceInDollars(completionHandler: @escaping (_ value: Decimal) -> Void){
        let query = db.collection("prices").document("BTC")
        
        
        query.getDocument { (snapshot, error) in
            if error != nil{
                // ERROR occured
                completionHandler(0.0)
            }else{
                let data = snapshot?.data()
                let decimal = data!["USD"]
                print(decimal)
                
            }
        }
    }
}
