//
//  ViewController.swift
//  GivBit
//
//  Created by Tallal Javed on 5/7/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import Contacts

class MainVC: UIViewController {
    @IBOutlet var textViewSearchBar: UITextField!
    @IBOutlet var contactsTableView: UITableView!
    @IBOutlet var blurViewBehindSearchBar: UIVisualEffectView!
    
    var shouldAdjustTableForFirstLoading: Bool = true
    var contacts : [CNContact] = [CNContact]()
    var amountOfBtcInWallet: String = ""
    
    // MARK:- ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad - mainVC")
        
        let Coinbase_Linkage_Status = GlobalVariables.Coinbase_Linkage_Status
        print("Coinbase_Linkage_Status:"+Coinbase_Linkage_Status)
        // Do any additional setup after loading the view, typically from a nib.
        print(Auth.auth().currentUser?.displayName ?? "")
        
        self.navigationController?.hidesNavigationBarHairline = true
        
        // Contacts and Tableview
        ContactsManager.sharedInstance.loadContacts { (contacts, authStatus) in
            self.contacts = contacts!
            if authStatus == true{
                // we have access to the users accounts
            }else{
                // tell user for access
            }
            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }

            self.pushContactsOnFirebase()
        }
        
        // adjust the scrollview
        
        // firestore testing
        // just load the coinbase user
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUnlinkedCoinbaseNotification(_:)), name: NSNotification.Name(rawValue: "coinbaseIsUnlinkedNotification"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear Main")
        coinbaseoauth.sharedInstnace.checkIfCoinbaseUnlinked()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear Main")
        // hide the top and bottom bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // show bottom bar
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        // set scroolview contentinset for tableview to make the header come down
        self.contactsTableView.contentInset = UIEdgeInsetsMake(self.blurViewBehindSearchBar.frame.height, 0, 0, 0)
        self.contactsTableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.blurViewBehindSearchBar.frame.height, 0, 0, 0)
        // Make the top cell to adjust with respect to our new insets. Else it will stay in its default position
        if contacts.count > 0 && shouldAdjustTableForFirstLoading{
            shouldAdjustTableForFirstLoading = false
            self.contactsTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Coinbase Linkage State
    
    @objc func handleUnlinkedCoinbaseNotification(_ notification: Notification){
        handleUnlinkedCoinbase();
    }
    
    
    //NotificationCenter.default.addObserver(self, selector: #selector(self.receivedInvoiceNoticationFunction(_:)), name: NSNotification.Name(rawValue: "rececivedInvoiceNotification"), object: nil)
    



//Hmmmm...looks like sometimes we dont get the notification, maybe need to poll too?
//@objc func receivedInvoiceNoticationFunction(_ notification: NSNotification) {
    
    
        
    func handleUnlinkedCoinbase(){
        print("handleUnlinkedCoinbase")
        let Coinbase_Linkage_Status = GlobalVariables.Coinbase_Linkage_Status
        print("Coinbase_Linkage_Status:"+Coinbase_Linkage_Status)
        if (Coinbase_Linkage_Status == "UNLINKED"){
            DispatchQueue.main.async {
                CustomNotificationHelper.sharedInstance.addNotificationAtBottomForCoinbaseRelinking(inViewController: self)
               // self.performSegue(withIdentifier: "settingSegue", sender: self)
            }
        }
    }
    
    // MARK: - Actions on SearchBar change Data
    @IBAction func didChangeInSearch(){
        let strindToSearch = textViewSearchBar.text
         ContactsManager.sharedInstance.getSearchForContacts(searchString:strindToSearch!, completionHandler: { (contacts, authStatus) in
            self.contacts = contacts
        
            
            self.contactsTableView.reloadData()
        })
    }

    // MARK: - Actions
    // the lord wants to log out - process it plz.
    @IBAction func didTapOnLogoutButton(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // called when the user taps vendor button
    @IBAction func didTapOnVendorButtton(sender: NSObject){
        // check if the vendor is present in the cache of database inside firebase
        FirestoreHelper.sharedInstnace.getUserVendorInfo(fromCache: true) { (info, error) in
            if error != nil{
                AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Sorry, something went wrong. Please try again.", andTitle: "Error")
            }else{
                if info != nil{
                    self.performSegue(withIdentifier: "vendorWelcomeSegue", sender: self)
                }else{
                    self.performSegue(withIdentifier: "vendorCreateInvoiceSegue", sender: self)
                }
            }
        }
    }
    
    
    //MARK: - Navigation
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue){
        // did unwind back to current view
        print("unwindToMain called")
        if (self.contactsTableView.indexPathForSelectedRow != nil){
            self.contactsTableView.deselectRow(at: self.contactsTableView.indexPathForSelectedRow!, animated: false)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingSegue"{
            //Maybe don't need this?
        }else if segue.identifier == "userSendMoneySegue"{
            let destinationController = segue.destination as! SendCoinVC
            let selectedContactIndex = self.contactsTableView.indexPathForSelectedRow?.row
            let contact = GBContact()
            contact.populateWith(CNContact: contacts[selectedContactIndex!])
            destinationController.contact = contact
            print("self.amountOfBtcInWallet")
            print(self.amountOfBtcInWallet)

            destinationController.amountOfBtcInWallet = self.amountOfBtcInWallet

            //let isFavourite = self.contactsTableView.indexPathForSelectedRow?.section ?? 0??1
        }
    }
    
    
    /*func ifCoinbaseTokenInvalidSendToSettingsPage(){
        self.functions.httpsCallable("isCoinbaseTokenValid").call([]) { (result, error) in
            print("done calling isCoinbaseTokenValid")
            if error != nil{
                print("Error performing function isCoinbaseTokenValid \(String(describing: error?.localizedDescription))")
            }else{
                print("isCoinbaseTokenValid returned")
                print(result?.data ?? "")
                let data = result?.data as! [String: Any]
                if data["error"] != nil{
                    print("error checking isCoinbaseTokenValid")
                    print(data["error"] as! String)
                }else{
                    let isValid = data["success"] as! Bool
                    if (isValid == false){
                        print("not valid token, have to relink - send to settings")
                       
                    }
            }
        }
    }*/
    
    func updateNumberToFireBase(){
        if Auth.auth().currentUser?.providerData[0].providerID == "phone"{
            
            FirestoreHelper.sharedInstnace.updateUserContactOnFirebase(universalUserID: (Auth.auth().currentUser?.uid)!,completionHandler: { (success) in
                if success == true{
                    
                }else{
                    
                }
                
            }
                
            )
        }
    }
}

// MARK:- Tableview
extension MainVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "userSendMoneySegue", sender: self)
    }
}

extension MainVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if contacts != nil{
            return contacts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "contact-cell") as! ContactTBVCell
            cell.populateCellWithContact(contact: contacts[indexPath.row])
            return cell
        }
        else if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "contact-cell") as! ContactTBVCell
            cell.populateCellWithContact(contact: contacts[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            return tableView.dequeueReusableCell(withIdentifier: "favorite-label-cell")?.contentView
        }
        if section == 0{
            return tableView.dequeueReusableCell(withIdentifier: "friends-label-cell")?.contentView
        }
        return UIView()
    }
    func pushContactsOnFirebase(){
        
        FirestoreHelper.sharedInstnace.updateUserContactOnFirebase(universalUserID :(Auth.auth().currentUser?.uid)!){ ( success) in
            // Check if user already exists in the database
            if success == true{
              
            }
        }
    }
}

struct globals {
    static var  btcInWalletGlobal  = ""
}
