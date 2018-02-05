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
    var currentPanel : PanelModel!
    
    @IBOutlet weak var stackView: NSStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPanel = settingsUtility.getSettings();
        
        for (index, setting) in currentPanel.enumerated() {
            let button = NSButton.init()
            button.setButtonType(.switch)
            button.state = setting.checked ? .on : .off
            button.title = setting.applicationName
            button.tag = index
            button.target = self
            button.action = #selector(clickedCheckbox(_:))
            stackView.addView(button, in: NSStackView.Gravity.bottom)
        }
    }
    
    @objc func clickedCheckbox(_ sender: NSButton) {
        currentPanel = currentPanel.toggleSetting(atIndex: sender.tag)
    }
    
    @IBAction func quitAllButtonClicked(_ sender: Any) {
        delegate.didPerformAction()
        openApplication(applicationName: "Quit All")
    }
    
    @IBAction func openDevButtonClicked(_ sender: Any) {
        delegate.didPerformAction()
        
        currentPanel.forEach { (setting) in
            if (setting.checked) {
                openApplication(applicationName: setting.applicationName)
            }
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        delegate.didPerformAction()
        
        
        if (segue.identifier?.rawValue == "showSettingsSegue") {
            if let destinationVc = segue.destinationController as? SettingsViewController {
                destinationVc.settingsUtility = settingsUtility
            }
        }
    }
    
    func openApplication(applicationName : String) {
        let path = "/Applications/" + applicationName + ".app"
        let url = URL.init(fileURLWithPath: path, isDirectory: false)
        
        do {
            try NSWorkspace.shared.launchApplication(at: url,
                                                     options: NSWorkspace.LaunchOptions.withoutActivation,
                                                     configuration: [:])
        } catch {
            print("error")
        }
    }
}

extension WorkspaceViewController {
    static func freshController(delegate: WorkspaceDelegate, settingsUtility: SettingsUtility) -> WorkspaceViewController {
        let mainStoryboard =  NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        guard let viewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "WorkspaceViewController")) as? WorkspaceViewController else {
            fatalError("Why can't I find WorkspaceViewController? - Check Main.storyboard")
        }
        viewController.delegate = delegate
        viewController.settingsUtility = settingsUtility
        return viewController
    }
}

