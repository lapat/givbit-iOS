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
import FirebaseFunctions
class FirestoreHelper: NSObject {

    static var sharedInstnace = FirestoreHelper()
    let db = Firestore.firestore()
    var functions = Functions.functions()

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
    
    // gets the users coinbase info
    func fetchCoinbaseUserInfoObjetForUser(givbitUser user: GBUser, completionHandler: @escaping (_ user: GBCoinbaseUser?,_ success: Bool) -> Void){
        let query = db.collection("coinbase_users").whereField("uid", isEqualTo: user.uuid)
        query.getDocuments { (querySnapshot, error) in
            if error != nil{
                completionHandler(nil, false)
            }else{
                // only one document will exist
                // check if a document exists:
                if (querySnapshot?.documents.count)! > 0{
                    let coinbaseUser = GBCoinbaseUser.sharedInstance
                    let document = querySnapshot?.documents[0]
                    coinbaseUser.country = document?.data()["country"] as! String
                    coinbaseUser.email = document?.data()["email"] as! String
                    coinbaseUser.name = document?.data()["name"] as! String
                    coinbaseUser.nativeCurrency = document?.data()["native_currency"] as! String
                    coinbaseUser.profilePic = document?.data()["profile_pic"] as! String
                    coinbaseUser.uid = document?.data()["uid"] as! String
                    coinbaseUser.hasUser = true
                    completionHandler(coinbaseUser, true)
                }else{
                    completionHandler(nil, true)
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
                    let user = GBUser.sharedUser
                    user.fullName = document.data()["name"] as! String
                    user.phoneNumber = document.data()["phone_number"] as! String
                    user.coinbaseRefreshToken = document.data()["coinbase_refresh_token"] as! String
                    user.coinbaseToken = document.data()["coinbase_token"] as! String
                    user.uuid = document.data()["uid"] as! String
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
        //MONEY I SENT
        let query = db.collection("transactions").whereField("sender_uid", isEqualTo: uuid)
        var transactions = [GBTransaction]()
        var transactions2 = [GBTransaction]()

        query.getDocuments { (querySnapShot, error) in
            if error != nil{
                // Error occured
                completionHandler([GBTransaction](), false)
            }else{
                for document in querySnapShot!.documents{
                    let transaction = GBTransaction()
                    transaction.cryptoAmount = document.data()["btc_amount"] as! Double
                    transaction.coinbaseItemID = document.data()["coinbase_idem_id"] as! String
                    transaction.date = document.data()["date"] as! TimeInterval/1000
                    transaction.pending = document.data()["pending"] as! Bool
                    transaction.recieverPhoneNumber = document.data()["receiver_phone_number"] as! String
                    transaction.recieverUID = document.data()["receiver_uid"] as! String
                    transaction.senderUID = document.data()["sender_uid"] as! String
                    transaction.recieverName = document.data()["receiver_name"] as! String
                    transaction.senderName = document.data()["sender_name"] as! String
                    transaction.sent = true
                    transactions.append(transaction)
                }
                //completionHandler(transactions, true)
            }
        
            //MONEY I RECEIVED
            let queryReceiver = self.db.collection("transactions").whereField("receiver_uid", isEqualTo: uuid)
            queryReceiver.getDocuments { (querySnapShot, error) in
                if error != nil{
                    // Error occured
                    completionHandler([GBTransaction](), false)
                }else{
                    //var transactions = [GBTransaction]()
                    for document in querySnapShot!.documents{
                        let transaction = GBTransaction()
                        transaction.cryptoAmount = document.data()["btc_amount"] as! Double
                        transaction.coinbaseItemID = document.data()["coinbase_idem_id"] as! String
                        transaction.date = document.data()["date"] as! TimeInterval/1000
                        transaction.pending = document.data()["pending"] as! Bool
                        transaction.recieverPhoneNumber = document.data()["receiver_phone_number"] as! String
                        transaction.recieverUID = document.data()["receiver_uid"] as! String
                        transaction.senderUID = document.data()["sender_uid"] as! String
                        transaction.recieverName = document.data()["receiver_name"] as! String
                        transaction.senderName = document.data()["sender_name"] as! String
                        transaction.sent = false
                        transactions.append(transaction)
                    }
                }
                transactions2 = transactions.sorted(by: { $0.date > $1.date })
                //transactions.sort{
                //    (($0 )["date"] as? Int)! < (($1 as! GBTransaction)["date"] as? Int)!
                //}
                completionHandler(transactions2, true)
            }
        }
       


    }
    
    func updateCoinbaseidOnCoinbaseWithUUID(universalUserID uuid: String,code : String, completionHandler: @escaping (_ success: Bool, _ email: String) -> Void) {
        let tokens = ["code": code ]
        
        let user = Auth.auth().currentUser
        if user != nil{
            // Add a new document with a generated ID
                
            functions.httpsCallable("linkCoinbaseWithCode").call(["code":code ,"uriRedirect":coinbaseoauth.sharedInstnace.redirectUrl]) { (result, error) in
                print("linkCoinbaseWithCode returned");
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        print("got error");
                        print(error.localizedDescription);
                        let code = FunctionsErrorCode(rawValue: error.code)
                        let message = error.localizedDescription
                        let details = error.userInfo[FunctionsErrorDetailsKey]
                        completionHandler(false, "")
                    }
                }
                else{
                    print("printing result.data");
                    
                    
                    let data = result?.data as! [String: Any]
                    if data["error"] != nil{
                        print("error checking isCoinbaseTokenValid")
                        print(data["error"] as! String)
                    }else{
                        
                        let data = result?.data as! [String: Any]
                        if data["email"] != nil{
                            print("email")
                            print(data["email"] as! String);
                            completionHandler(true, data["email"] as! String)
                        }
                    }
                
                }
            }
            
            /*
            let ref: DocumentReference? = db.collection("users").document(uuid)
            ref!.updateData(tokens){ err in
                if var err = err {
                    
                } else {
                    
                }
            }*/
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
    
    // starts a snapshot listener and makes sure the completion handler is called, whenever the value for a specific object changes
    func startBTCPriceInDollarsSnapshotListener( completionHandler: @escaping (_ value: NSNumber) -> Void) -> ListenerRegistration{
        let query = db.collection("prices").document("BTC")
        let listener = query.addSnapshotListener(includeMetadataChanges: false) { (docSnapshot, error) in
            if error != nil{
                // error occured
                completionHandler(0.0)
            }else{
                let data = docSnapshot?.data()
                let decimal = data!["USD"] as! NSNumber
                completionHandler(decimal)
            }
        }
        return listener
    }
    
    func getBTCPriceInDollars(completionHandler: @escaping (_ value: Double?, _ status: Bool) -> Void){
        let query = db.collection("prices").document("BTC")
        query.getDocument { (documentSnaptshot, error) in
            if error != nil{
                completionHandler(nil, false)
            }else{
                let data = documentSnaptshot?.data()!
                let value = data!["USD"] as! Double
                completionHandler(value, true)
            }
        }
    }
}
