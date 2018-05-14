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
    
    @IBOutlet var contactsTableView: UITableView!
    var contacts : [CNContact] = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(Auth.auth().currentUser?.displayName ?? "")
        
        self.navigationController?.hidesNavigationBarHairline = true
        
        ContactsManager.sharedInstance.loadContacts { (contacts, authStatus) in
            self.contacts = contacts!
            if authStatus == true{
                // we have access to the users accounts
            }else{
                // tell user for access
            }
            self.contactsTableView.reloadData()
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
}

// MARK:- Tableview
extension MainVC: UITableViewDelegate{
    
}

extension MainVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "contact-cell") as! ContactTBVCell
            cell.populateCellWithContact(contact: contacts[indexPath.row])
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "contact-cell") as! ContactTBVCell
            cell.populateCellWithContact(contact: contacts[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return tableView.dequeueReusableCell(withIdentifier: "favorite-label-cell")
        }
        if section == 1{
            return tableView.dequeueReusableCell(withIdentifier: "friends-label-cell")
        }
        return UIView()
    }
}

