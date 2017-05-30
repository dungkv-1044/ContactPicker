//
//  ContactTableViewController.swift
//  Contact
//
//  Created by Khuat Van Dung on 5/29/17.
//  Copyright © 2017 Khuat Van Dung. All rights reserved.
//

import UIKit
import Contacts
class ContactTableViewController: UITableViewController {

    
    
    var contactSection = [String]()
    var contactDict = [String: [Contact]]()
    
    func generateContactDict() {
        for contact in ContactServices.sharedContact.contacts {
            let key = "\(contact.name[contact.name.startIndex])"
            let upper = key.uppercased()
            if var contactValues = contactDict[upper] {
                contactValues.append(contact)
                contactDict[upper] = contactValues
            }
            else {
                contactDict[upper] = [contact]
            }
        }
        contactSection = [String](contactDict.keys)
        contactSection = contactSection.sorted()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateContactDict()
        self.tableView.allowsMultipleSelection = true
        
       
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactSection.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactSection[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let contactKey = contactSection[section]
        if let contactValues = contactDict[contactKey] {
            return contactValues.count
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contactKey = contactSection[indexPath.section]
        if let contactValues = contactDict[contactKey.uppercased()] {
            let contact = contactValues[indexPath.row]
            cell.textLabel?.text = contact.name
            cell.detailTextLabel?.text = contact.phone

        }
        
        return cell
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactSection
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = contactSection.index(of: title) else {
            return -1
        }
        return index
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        let contactKey = contactSection[indexPath.section]
        if let contactValues = contactDict[contactKey.uppercased()] {
            let contact = contactValues[indexPath.row]
            let key = (cell?.textLabel?.text)! + "#" + (cell?.detailTextLabel?.text)!
            ContactServices.sharedContact.selectedContacts[key] = contact

        }
       
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        let contactKey = contactSection[indexPath.section]
        if contactDict[contactKey.uppercased()] != nil {            
            let key = (cell?.textLabel?.text)! + "#" + (cell?.detailTextLabel?.text)!
            ContactServices.sharedContact.selectedContacts.removeValue(forKey: key)
            
        }
    }
    
    
}
