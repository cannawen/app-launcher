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
        if (!hasSavedSettings()) {
            let settingsArray : [Setting] = [
                Setting.init(applicationName: "Google Chrome", checked : true),
                Setting.init(applicationName: "iTerm", checked : true),
                Setting.init(applicationName: "Sourcetree", checked : true),
                Setting.init(applicationName: "Sublime Text", checked : false),
                Setting.init(applicationName: "Android Studio", checked : false),
                Setting.init(applicationName: "IntelliJ IDEA CE", checked : false),
                Setting.init(applicationName: "Xcode", checked : false)
            ]
            save(settings: settingsArray)
        }
    }
    
    private func preferencesFileUrl() -> URL {
        let documentsUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return documentsUrl.appendingPathComponent(".app-launcher-preferences.txt")
    }
    
    private func hasSavedSettings() -> Bool {
        return FileManager.default.fileExists(atPath: preferencesFileUrl().path)
    }
    
    private func save(settings: [Setting]) {
        try! Setting.toJson(settings: settings).write(to: preferencesFileUrl(), atomically: true, encoding: String.Encoding.utf8)
    }
    
    func getSettings() -> [Setting] {
        let jsonString = try! String(contentsOf: preferencesFileUrl(), encoding: .utf8)
        return Setting.from(jsonString: jsonString)
    }
    
    struct Setting {
        static let ApplicationNameKey = "ApplicationName"
        static let CheckedKey = "CheckedByDefault"
        
        var applicationName : String
        var checked : Bool
        
        init(jsonString: String) {
            let jsonData = jsonString.data(using: .utf8)!
            let decoded = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            
            let dict = decoded as! [String:Any]
            self.applicationName = dict[Setting.ApplicationNameKey] as! String
            self.checked = dict[Setting.CheckedKey] as! Bool
        }
        
        init(applicationName : String, checked : Bool) {
            self.applicationName = applicationName
            self.checked = checked
        }
        
        mutating func toggleChecked() {
            checked = !checked;
        }
        
        static func toJson(settings : [Setting]) -> String {
            let array = settings.map { (setting) -> [String : Any] in
                return [Setting.ApplicationNameKey : setting.applicationName,
                        Setting.CheckedKey : setting.checked]
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            let convertedString = String(data: jsonData, encoding: String.Encoding.utf8)
            return convertedString!
        }
        
        static func from(jsonString : String) -> [Setting] {
            let jsonData = jsonString.data(using: .utf8)!
            let decoded = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            
            let arr = decoded as! [[String:Any]]
            return arr.map({ (dict) -> Setting in
                return Setting.init(applicationName: dict[Setting.ApplicationNameKey] as! String,
                                    checked: dict[Setting.CheckedKey] as! Bool)
            })
        }
    }
}
