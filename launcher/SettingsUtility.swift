//
//  SettingsUtility.swift
//  launcher
//
//  Created by Canna Wen on 2018-01-31.
//  Copyright © 2018 Canna Wen. All rights reserved.
//

import Cocoa

struct SettingsUtility {
    
    init() {
        if (!userDefaults().bool(forKey: "initialized")) {
            let settingsArray = [
                ["applicationName" : "Google Chrome", "checked" : true],
                ["applicationName" : "iTerm", "checked" : true],
                ["applicationName" : "Sourcetree", "checked" : true],
                ["applicationName" : "Sublime Text", "checked" : false],
                ["applicationName" : "Android Studio", "checked" : false],
                ["applicationName" : "IntelliJ IDEA CE", "checked" : false],
                ["applicationName" : "Xcode", "checked" : false]
            ]
            save(settings: settingsArray)
            userDefaults().setValue(true, forKey: "initialized")
        }
    }
    
    func settings() -> [Setting] {
        return getSettings().map({ (dict) -> Setting in
            return Setting.init(applicationName: dict["applicationName"] as! String,
                                checked: dict["checked"] as! Bool)
        })
    }
    
    private func userDefaults() -> UserDefaults {
        return NSUserDefaultsController.shared().defaults;
    }
    
    private func save(settings: [[String: Any]]) {
        userDefaults().setValue(settings, forKey: "settingsArray")
    }
    
    private func getSettings() -> [[String: Any]] {
        return userDefaults().array(forKey: "settingsArray") as! [[String : Any]]
    }
    
    struct Setting {
        var applicationName : String
        var checked : Bool
        
        init(applicationName : String, checked : Bool) {
            self.applicationName = applicationName
            self.checked = checked
        }
        
        mutating func toggleChecked() {
            checked = !checked;
        }
    }
}
