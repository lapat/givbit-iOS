//
//  ContactsManager.swift
//  GivBit
//
//  Created by Tallal Javed on 5/14/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Contacts

class ContactsManager: NSObject {
    // Use this for access to a universal contacts manager lib
    static var sharedInstance: ContactsManager = ContactsManager()
    var contactStore = CNContactStore()
    lazy var contacts: [CNContact] = {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return results
    }()
    
    func checkAuthorizationStatus(completionHandler: @escaping (_ status: Bool) -> Void){
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .denied, .notDetermined:
            // ask user for access
            self.contactStore.requestAccess(for: CNEntityType.contacts) { (access, error) in
                if access {
                    completionHandler(true)
                }else{
                    completionHandler(false)
                }
            }
            
        case .restricted:
            completionHandler(false)
        }
    }
    
    // Returns nil if there is a issue with loading contacts
    func loadContacts(completionHandler: @escaping (_  contacts:[CNContact]?, _ authStatus: Bool) -> Void){
        self.checkAuthorizationStatus(completionHandler: { (status) in
            if status == true{
                // Load the contacts
                completionHandler(self.contacts, true)
            }else{
                // Contact Authorization issue
                completionHandler(self.contacts, false)
            }
        })
    }
}
