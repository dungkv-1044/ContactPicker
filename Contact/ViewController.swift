//
//  ViewController.swift
//  Contact
//
//  Created by Khuat Van Dung on 5/29/17.
//  Copyright © 2017 Khuat Van Dung. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToNewEvent(sender: UIStoryboardSegue) {
        if sender.source is ContactTableViewController {
            for contact in ContactServices.sharedContact.selectedContacts {
                print(contact.value.name)
//                print(contact.key)
            }
            
            ContactServices.sharedContact.clearSelectedContacts()
            
        }
    
    
    }
    
    
    
}

