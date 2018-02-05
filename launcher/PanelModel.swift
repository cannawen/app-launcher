//
//  PanelModel.swift
//  launcher
//
//  Created by Canna Wen on 2018-02-05.
//  Copyright © 2018 Canna Wen. All rights reserved.
//

import Foundation

struct PanelModel: Collection {
    private var settings : [SettingModel]!
    
    init(settings : [SettingModel]) {
        self.settings = settings
    }
    
    var startIndex: Int {
        return settings.startIndex
    }
    
    var endIndex: Int {
        return settings.endIndex
    }
    
    subscript (position: Int) -> SettingModel {
        precondition(indices.contains(position), "out of bounds")
        return settings[position]
    }
    
    func index(after i: Int) -> Int {
        return settings.index(after: i)
    }
    
    func toJson() -> String {
        return SettingModel.toJson(settings: settings)
    }
    
    func toggleSetting(atIndex index: Int) -> PanelModel {
        return PanelModel.init(settings: settings.enumerated().map({ (i, element) -> SettingModel in
            if (i == index) {
                return SettingModel.init(applicationName: element.applicationName, checked: !element.checked)
            } else {
                return element
            }
        }))
    }
}
