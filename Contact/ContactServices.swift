//
//  ContactServices.swift
//  Contact
//
//  Created by Khuat Van Dung on 5/29/17.
//  Copyright © 2017 Khuat Van Dung. All rights reserved.
//

import Foundation
import Contacts
class ContactServices {
    static let sharedContact : ContactServices = ContactServices()
    private var _contacts : [Contact]?
    var contacts : [Contact] {
        set {
            _contacts = newValue
        }
        get {
            if _contacts == nil {
                fetchContacts()
            }
            return _contacts ?? []
        }
    }
    
    private var _selectedContacts : [String : Contact]?
    
    var selectedContacts : [String: Contact] {
        set {
            _selectedContacts = newValue
        }
        get {
            return _selectedContacts ?? [:]
        }
    }
    
    func clearSelectedContacts() {
        _selectedContacts = [:]
    }
    
    func fetchContacts() {
        _contacts = []
        let contactStore = CNContactStore()
        let keys = [CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey, CNContactPhoneNumbersKey]
        let request1 = CNContactFetchRequest(keysToFetch: keys  as [CNKeyDescriptor])
        
        try? contactStore.enumerateContacts(with: request1) { (contact, error) in
            for phone in contact.phoneNumbers {
                let cont = Contact(name: contact.givenName, phone: phone.value.stringValue)
                self._contacts?.append(cont)
            }
        }
        
//        let c1 = Contact(name: "Abdsa", phone: "019231231")
//        let c2 = Contact(name: "dasdasd", phone: "1231231232")
//        let c3 = Contact(name: "fbdsa", phone: "123")
//        let c4 = Contact(name: "kaasdasd", phone: "456")
//        let c5 = Contact(name: "hbdsa", phone: "789")
//        let c6 = Contact(name: "nasdasd", phone: "0123")
//        self._contacts = [c1,c2,c3,c4,c5,c6]
    }
    
}
