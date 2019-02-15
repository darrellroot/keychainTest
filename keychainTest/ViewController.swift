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
    let keychainService = "KeychainService"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func addKeychainButton(_ sender: NSButton) {
        let addQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: keychainService,
                                       kSecAttrAccount as String: serverHostname,
                                       kSecValueData as String: inputTextOutlet.stringValue]
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        //let passwordData: NSData = inputTextOutlet.stringValue.data(using: String.Encoding.utf8, allowLossyConversion: false) as! NSData
        if let error = SecCopyErrorMessageString(status, nil) {
            let errorString = String(error)
            statusLabel.stringValue = errorString
        } else {
            statusLabel.stringValue = status.description
        }
    }
    
    @IBAction func updateKeychainButton(_ sender: NSButton) {
        let updateQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrService as String: keychainService,
                                          kSecAttrAccount as String: serverHostname]
         let newAttributes: [String: Any] = [kSecValueData as String: inputTextOutlet.stringValue]
         let status = SecItemUpdate(updateQuery as CFDictionary, newAttributes as CFDictionary)
        if let error = SecCopyErrorMessageString(status, nil) {
            let errorString = String(error)
            statusLabel.stringValue = errorString
        } else {
            statusLabel.stringValue = status.description
        }
    }
    
    @IBAction func getKeychainData(_ sender: NSButton) {
        let getQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: serverHostname,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true]
        var rawResult: AnyObject?
        //var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &rawResult)
        if let error = SecCopyErrorMessageString(status, nil) {
            let errorString = String(error)
            statusLabel.stringValue = errorString
        } else {
            statusLabel.stringValue = status.description
        }

        //guard let existingItem = item as? [String : Any] else { return }
        
        guard let retrievedData = rawResult as? Data else { return }
        guard let pass = String(data: retrievedData, encoding: String.Encoding.utf8) else { return }
        //guard let retrievedData = rawResult as? NSData else { return }
        //guard let nspass = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue) else { return }
        //let pass = String(nspass)
        labelOutlet.stringValue = pass
        //let passwordData = existingItem[kSecValueData as String] as? Data,
/*        let keychainPassword = String(data: passwordData, encoding: String.Encoding.utf8),
            let keychainEmail = existingItem[kSecAttrAccount as String] as? String {
            labelOutlet.stringValue = "password \(keychainPassword) email \(keychainEmail)"
        } else {
            labelOutlet.stringValue = "Failure"
        }*/
    }
    @IBAction func eraseKeychainData(_ sender: NSButton) {
        let deleteQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrService as String: keychainService,
                                          kSecAttrAccount as String: serverHostname]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if let error: CFString = SecCopyErrorMessageString(status, nil) {
            let errorString = String(error)
            statusLabel.stringValue = errorString
        } else {
            statusLabel.stringValue = status.description
        }
    }
    
    @IBAction func clearLabels(_ sender: NSButton) {
        statusLabel.stringValue = ""
        labelOutlet.stringValue = ""
    }
}

