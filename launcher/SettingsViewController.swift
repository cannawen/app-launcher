//
//  SettingsViewController.swift
//  launcher
//
//  Created by Canna Wen on 2018-01-31.
//  Copyright © 2018 Canna Wen. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    var settingsUtility: SettingsUtility!

    @IBOutlet weak var tableView: NSTableView!
    var settingsArray : [SettingsUtility.Setting]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsArray = settingsUtility.settings()
        
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return settingsArray[row] 
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let setting = settingsArray[row]
        
        if tableColumn == tableView.tableColumns[0] {
            if let cell = tableView.make(withIdentifier: "applicationName", owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = setting.applicationName
                return cell
            }
        } else if tableColumn == tableView.tableColumns[1] {
            if let cell = tableView.make(withIdentifier: "checked", owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = setting.checked ? "true" : "false"
                return cell
            }
        }
        return nil
    }
    
    @IBAction func quitButtonClicked(_ sender: Any) {
        NSApp.terminate(self)
    }
}
