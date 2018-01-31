//
//  SettingsViewController.swift
//  launcher
//
//  Created by Canna Wen on 2018-01-31.
//  Copyright © 2018 Canna Wen. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    var settingsArray = [[String: Any?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        let userDefaults = NSUserDefaultsController.shared().defaults;
        if let settings = userDefaults.array(forKey: "settingsArray") as? [[String : Any?]] {
            settingsArray = settings
            tableView.reloadData()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return settingsArray[row] 
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = settingsArray[row]
        
        if tableColumn == tableView.tableColumns[0] {
            if let cell = tableView.make(withIdentifier: "applicationName", owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = item["applicationName"] as! String
                return cell
            }
        } else if tableColumn == tableView.tableColumns[1] {
            if let cell = tableView.make(withIdentifier: "checked", owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = item["checked"] as! Bool ? "true" : "false"
                return cell
            }
        }
        return nil
    }
    
    @IBAction func quitButtonClicked(_ sender: Any) {
        NSApp.terminate(self)
    }
}
