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
    // the fav contacts array
    var favContacts: [CNContact] = [CNContact]()
    // the normal contacts array sorted in most useable probability
    var normalContacts: [CNContact] = [CNContact]()
    // the search results for contacts search
    var searchedContacts:[CNContact] = [CNContact]()
    // converted contactes into GBcontacts
    var convertedContacts:[GBContact] = [GBContact]()
    
    // loads all contacts from the contact store
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
        
        // used to hold cleaned contacts
        var cleanedResults = [CNContact]()
        // find the contacts who dont have a number associated with them
        for i in results{
            let contact: CNContact = i as CNContact
            if(contact.phoneNumbers.count<=0){
                continue
            }
            let name = CNContactFormatter.string(from: contact, style: CNContactFormatterStyle.fullName)
            if (name == nil){
               continue
            }
            cleanedResults.append(i)
            
        }
        print("PhoneNumbers: %d",cleanedResults.count)
        //self.convertToGBContacts()
        return cleanedResults
    }()
    
    // Checks the authorization status from users auth.
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
    
    // returns the fav contacts array
    func getFavContacts(completionHandler: @escaping (_ contacts: [CNContact]?, _ authStatus: Bool) -> Void){
        self.checkAuthorizationStatus { (status) in
            if status{
                completionHandler(self.favContacts, true)
            }else{
                completionHandler(self.favContacts, false)
            }
        }
    }
    
    // returns normal contacts array
    func getNormalContacts(completionHandler: @escaping (_ contacts: [CNContact], _ authStatus: Bool) -> Void){
        self.checkAuthorizationStatus { (status) in
            if status{
                completionHandler(self.normalContacts, true)
            }else{
                completionHandler(self.normalContacts, false)
            }
        }
    }
    
    // Searches the contacts for given string (name) and retuns the results
    func getSearchForContacts(searchString :String, completionHandler: @escaping (_ contacts: [CNContact], _ authStatus: Bool) -> Void){
        searchedContacts.removeAll()
        
        self.checkAuthorizationStatus { (status) in
            // Perform a search with given string
            if status{
                if searchString != "" {
                    let predicates = NSPredicate(format: CNContactGivenNameKey + " CONTAINS[cd] %@", searchString)
                    self.searchedContacts = (self.contacts as NSArray).filtered(using: predicates) as! [CNContact]
                }
                else{
                    self.searchedContacts = self.contacts
                }
                completionHandler(self.searchedContacts, true)
            }else{
                completionHandler(self.searchedContacts, false)
            }
        }
    }
    
    func getGBContact(forCNContact contact: CNContact) -> GBContact{
        var gbContact = GBContact()
        if contact.phoneNumbers.count > 0 {
            
        }
        return GBContact()
    }
    
    // convert current contacts to GbContacts
    func convertToGBContacts(){
        
        for contact in self.contacts {
            let gbcontact = GBContact()
            gbcontact.populateWith(CNContact: contact)
            self.convertedContacts.append(gbcontact)
        }
        
    }
    
    // MARK: - Favourites
    // Gives a fav contact for index
    func getFavContact(atIndex: Int) -> GBContact{
        return GBContact()
    }
    
    func getFavContactCount() -> Int{
        return 0
    }
    
    // MARK: - Gen Contacts
    func getGeneralContact(atIndex: Int) -> GBContact{
        return GBContact()
    }
    
    func getGeneralContactsCount() -> Int{
        return 0
    }
    
    // MARK: - Search Results
    // performs a search with respective item - Returns the number of results found
    func performSearch(searchTerm: String, completionhandler: @escaping (_ count: Int)-> Void){
        completionhandler(0)
    }
    
    func getSearchContactFromSearchResult(atIndex: Int) -> GBContact{
        return GBContact()
    }
    
    func getSearchedContactsCount() -> Int{
        return 0
    }
}
