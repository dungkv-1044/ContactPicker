//
//  ContactTableViewController.swift
//  Contact
//
//  Created by Khuat Van Dung on 5/29/17.
//  Copyright © 2017 Khuat Van Dung. All rights reserved.
//

import UIKit
import Contacts
class ContactTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    //MARK: Search bar
    var filteredArray: [Contact] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: itemTitle for section
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
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        } else {
            return contactSection.count
        }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return ""
        } else {
            return contactSection[section]
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            print("//das")
            return self.filteredArray.count
        } else {
            let contactKey = contactSection[section]
            if let contactValues = contactDict[contactKey] {
                return contactValues.count
            }
            
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
                let contact = self.filteredArray[indexPath.row]
                cell.textLabel?.text = contact.name
                cell.detailTextLabel?.text = contact.phone
        } else {
            let contactKey = contactSection[indexPath.section]
            if let contactValues = contactDict[contactKey.uppercased()] {
                let contact = contactValues[indexPath.row]
                cell.textLabel?.text = contact.name
                cell.detailTextLabel?.text = contact.phone
                
            }
        }
        
        
        return cell
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return []
        } else {
            return contactSection
        }
        
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
       if searchController.isActive && searchController.searchBar.text != "" {
            return 0
       } else {
        guard let index = contactSection.index(of: title) else {
            return -1
        }
        return index
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        if searchController.isActive && searchController.searchBar.text != "" {
            let contact = self.filteredArray[indexPath.row]
            let key = (cell?.textLabel?.text)! + "#" + (cell?.detailTextLabel?.text)!
            ContactServices.sharedContact.selectedContacts[key] = contact
        } else {
            let contactKey = contactSection[indexPath.section]
            if let contactValues = contactDict[contactKey.uppercased()] {
                let contact = contactValues[indexPath.row]
                let key = (cell?.textLabel?.text)! + "#" + (cell?.detailTextLabel?.text)!
                ContactServices.sharedContact.selectedContacts[key] = contact
                
            }
        }
        
       
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        if searchController.isActive && searchController.searchBar.text != "" {
            let key = (cell?.textLabel?.text)! + "#" + (cell?.detailTextLabel?.text)!
            ContactServices.sharedContact.selectedContacts.removeValue(forKey: key)
            
        } else {
            let contactKey = contactSection[indexPath.section]
            if contactDict[contactKey.uppercased()] != nil {
                let key = (cell?.textLabel?.text)! + "#" + (cell?.detailTextLabel?.text)!
                ContactServices.sharedContact.selectedContacts.removeValue(forKey: key)
                
            }
        }
        
    }
    
    func filterContentForSearch(name: String) {
        self.filteredArray = ContactServices.sharedContact.contacts.filter() {
            nil != $0.name.range(of: name)
        }
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearch(name: searchController.searchBar.text!)
    }
    
}
