//
//  ViewController.swift
//  keychainTest
//
//  Created by Darrell Root on 2/14/19.
//  Copyright © 2019 Darrell Root. All rights reserved.
//

import Cocoa
import Security

class ViewController: NSViewController {

    @IBOutlet weak var inputTextOutlet: NSTextField!
    
    @IBOutlet weak var labelOutlet: NSTextField!
    
    @IBOutlet weak var statusLabel: NSTextField!
    let keychainTest = "Keychain Test"
    let serverHostname = "mail.nowhere.com"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func addKeychainButton(_ sender: NSButton) {
        let addQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                       kSecAttrAccount as String: "fakeemail@nowhere.com",
                                       kSecAttrServer as String: serverHostname,
                                       kSecValueData as String: inputTextOutlet.stringValue,
                                       kSecAttrProtocol as String: keychainTest]
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        statusLabel.stringValue = status.description
    }
    
    @IBAction func updateKeychainButton(_ sender: NSButton) {
        
        let updateQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: serverHostname]
        
        let newAttributes: [String: Any] = [kSecAttrAccount as String: "fakeemail@nowhere.com",
                                         kSecValueData as String: inputTextOutlet.stringValue]
        
        let status = SecItemUpdate(updateQuery as CFDictionary, newAttributes as CFDictionary)
        statusLabel.stringValue = status.description
    }
    
    
    @IBAction func getKeychainData(_ sender: NSButton) {
        let getQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: serverHostname,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
            kSecAttrProtocol as String: keychainTest]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        statusLabel.stringValue = status.description
        if let existingItem = item as? [String : Any],
        let passwordData = existingItem[kSecValueData as String] as? Data,
        let keychainPassword = String(data: passwordData, encoding: String.Encoding.utf8),
            let keychainEmail = existingItem[kSecAttrAccount as String] as? String {
            labelOutlet.stringValue = "password \(keychainPassword) email \(keychainEmail)"
        } else {
            labelOutlet.stringValue = "Failure"
        }
    }
    @IBAction func eraseKeychainData(_ sender: NSButton) {
        let deleteQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                          kSecAttrProtocol as String: keychainTest]

        let status = SecItemDelete(deleteQuery as CFDictionary)
        statusLabel.stringValue = status.description

    }
    
    @IBAction func clearLabels(_ sender: NSButton) {
        statusLabel.stringValue = ""
        labelOutlet.stringValue = ""
    }
}

