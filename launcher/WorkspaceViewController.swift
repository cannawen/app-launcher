//
//  WorkspaceViewController.swift
//  launcher
//
//  Created by Canna Wen on 2018-01-31.
//  Copyright © 2018 Canna Wen. All rights reserved.
//

import Cocoa

protocol WorkspaceDelegate {
    func didPerformAction()
}

class WorkspaceViewController: NSViewController {
    var delegate : WorkspaceDelegate!
    var settingsUtility: SettingsUtility!
    var currentSettings : [SettingsUtility.Setting]!
    
    @IBOutlet weak var stackView: NSStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, setting) in settingsUtility.settings().enumerated() {
            let button = NSButton.init()
            button.setButtonType(NSSwitchButton)
            button.state = setting.checked ? NSOnState : NSOffState
            button.title = setting.applicationName
            button.tag = index
            button.target = self
            button.action = #selector(clickedCheckbox(_:))
            stackView.addView(button, in: NSStackViewGravity.bottom)
        }
    }
    
    func clickedCheckbox(_ sender: NSButton) {
        currentSettings[sender.tag].toggleChecked()
    }
    
    @IBAction func openDevButtonClicked(_ sender: Any) {
        currentSettings.forEach { (setting) in
            if (setting.checked) {
                openApplication(applicationName: setting.applicationName)
            }
        }
        delegate.didPerformAction()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        delegate.didPerformAction()
        if (segue.identifier == "showSettingsSegue") {
            if let destinationVc = segue.destinationController as? SettingsViewController {
                destinationVc.settingsUtility = settingsUtility
            }
        }
    }
    
    func openApplication(applicationName : String) {
        let path = "/Applications/" + applicationName + ".app"
        let url = URL.init(fileURLWithPath: path, isDirectory: false)
        
        do {
            try NSWorkspace.shared().launchApplication(at: url,
                                                       options: NSWorkspaceLaunchOptions.withoutActivation,
                                                       configuration: [:])
        } catch {
            print("error")
        }
    }
}

extension WorkspaceViewController {
    static func freshController(delegate: WorkspaceDelegate, settingsUtility: SettingsUtility) -> WorkspaceViewController {
        let mainStoryboard =  NSStoryboard(name: "Main", bundle: nil)
        guard let viewController = mainStoryboard.instantiateController(withIdentifier: "WorkspaceViewController") as? WorkspaceViewController else {
            fatalError("Why can't I find WorkspaceViewController? - Check Main.storyboard")
        }
        viewController.delegate = delegate
        viewController.settingsUtility = settingsUtility
        viewController.currentSettings = settingsUtility.settings()
        return viewController
    }
}

