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
    
    var contacts : [CNContact] = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            self.contactsTableView.reloadData()
        }
        
        // adjust the scrollview
        
        // firestore testing
        //FirestoreHelper.sharedInstnace.saveLoggedInFirebaseUser()
    }
    
    // MARK: - Actions on SearchBar change Data
    @IBAction func didChangeInSearch(){
        let strindToSearch = textViewSearchBar.text
        ContactsManager.sharedInstance.getSearchForContacts(searchString:strindToSearch!, completionHandler: { (contacts, authStatus) in
            self.contacts = contacts
        
            
            self.contactsTableView.reloadData()
        })
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the top and bottom bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        // set scroolview contentinset for tableview to make the header come down
        self.contactsTableView.contentInset = UIEdgeInsetsMake(self.blurViewBehindSearchBar.frame.height, 0, 0, 0)
        self.contactsTableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.blurViewBehindSearchBar.frame.height, 0, 0, 0)
        // Make the top cell to adjust with respect to our new insets. Else it will stay in its default position
        if contacts.count > 0{
            self.contactsTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func didTapOnLogoutButton(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: - Navigation
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue){
        // did unwind back to current view
        self.contactsTableView.deselectRow(at: self.contactsTableView.indexPathForSelectedRow!, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userSendMoneySegue"{
            var destinationController = segue.destination as! SendCoinVC
            let selectedContactIndex = self.contactsTableView.indexPathForSelectedRow?.row
            let contact = GBContact()
            contact.populateWith(CNContact: contacts[selectedContactIndex!])
            destinationController.contact = contact
            //let isFavourite = self.contactsTableView.indexPathForSelectedRow?.section ?? 0??1
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
}
