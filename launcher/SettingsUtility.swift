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
            let settingsArray : [SettingModel] = [
                SettingModel.init(applicationName: "Google Chrome", checked : true),
                SettingModel.init(applicationName: "iTerm", checked : true),
                SettingModel.init(applicationName: "Sourcetree", checked : true),
                SettingModel.init(applicationName: "Sublime Text", checked : false),
                SettingModel.init(applicationName: "Android Studio", checked : false),
                SettingModel.init(applicationName: "IntelliJ IDEA CE", checked : false),
                SettingModel.init(applicationName: "Xcode", checked : false)
            ]
            save(settings: PanelModel.init(settings: settingsArray))
        }
    }
    
    private func preferencesFileUrl() -> URL {
        let documentsUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return documentsUrl.appendingPathComponent(".app-launcher-preferences.json")
    }
    
    private func hasSavedSettings() -> Bool {
        return FileManager.default.fileExists(atPath: preferencesFileUrl().path)
    }
    
    private func save(settings: PanelModel) {
        try! settings.toJson().write(to: preferencesFileUrl(), atomically: true, encoding: String.Encoding.utf8)
    }
    
    func getSettings() -> PanelModel {
        let jsonString = try! String(contentsOf: preferencesFileUrl(), encoding: .utf8)
        return PanelModel.init(settings: SettingModel.from(jsonString: jsonString))
    }
}
