//
//  SettingModel.swift
//  launcher
//
//  Created by Canna Wen on 2018-02-05.
//  Copyright © 2018 Canna Wen. All rights reserved.
//

import Foundation

struct SettingModel {
    static let ApplicationNameKey = "ApplicationName"
    static let CheckedKey = "CheckedByDefault"
    
    var applicationName : String
    var checked : Bool
    
    init(jsonString: String) {
        let jsonData = jsonString.data(using: .utf8)!
        let decoded = try! JSONSerialization.jsonObject(with: jsonData, options: [])
        
        let dict = decoded as! [String:Any]
        self.applicationName = dict[SettingModel.ApplicationNameKey] as! String
        self.checked = dict[SettingModel.CheckedKey] as! Bool
    }
    
    init(applicationName : String, checked : Bool) {
        self.applicationName = applicationName
        self.checked = checked
    }
    
    mutating func toggleChecked() {
        checked = !checked;
    }
    
    static func toJson(settings : [SettingModel]) -> String {
        let array = settings.map { (setting) -> [String : Any] in
            return [SettingModel.ApplicationNameKey : setting.applicationName,
                    SettingModel.CheckedKey : setting.checked]
        }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
        let convertedString = String(data: jsonData, encoding: String.Encoding.utf8)
        return convertedString!
    }
    
    static func from(jsonString : String) -> [SettingModel] {
        let jsonData = jsonString.data(using: .utf8)!
        let decoded = try! JSONSerialization.jsonObject(with: jsonData, options: [])
        
        let arr = decoded as! [[String:Any]]
        return arr.map({ (dict) -> SettingModel in
            return SettingModel.init(applicationName: dict[SettingModel.ApplicationNameKey] as! String,
                                     checked: dict[SettingModel.CheckedKey] as! Bool)
        })
    }
}
