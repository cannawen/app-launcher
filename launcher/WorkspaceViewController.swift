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
    
    @IBOutlet weak var stackView: NSStackView!
    var currentSettingsArray = [[String: Any?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = NSUserDefaultsController.shared().defaults;
        if let settings = userDefaults.array(forKey: "settingsArray") as? [[String : Any?]] {
            for (index, item) in settings.enumerated() {
                let button = NSButton.init()
                button.setButtonType(NSSwitchButton)
                button.state = item["checked"] as! Bool ? NSOnState : NSOffState
                button.title = item["applicationName"] as! String
                button.tag = index
                button.target = self
                button.action = #selector(clickedCheckbox(_:))
                stackView.addView(button, in: NSStackViewGravity.bottom)
            }
            currentSettingsArray = settings
        }
    }
    
    func clickedCheckbox(_ sender: NSButton) {
        currentSettingsArray[sender.tag]["checked"] = !(currentSettingsArray[sender.tag]["checked"] as! Bool)
    }
    
    @IBAction func openDevButtonClicked(_ sender: Any) {
        currentSettingsArray.forEach { (item) in
            if let checked = item["checked"] as? Bool,
               let application = item["applicationName"] as? String {
                if (checked) {
                    openApplication(applicationName: application)
                }
            }
        }
        delegate.didPerformAction()
    }
    
    @IBAction func settingsButtonClicked(_ sender: Any) {
        delegate.didPerformAction()
        performSegue(withIdentifier: "showSettingsSegue", sender: self)
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
    static func freshController(delegate: WorkspaceDelegate) -> WorkspaceViewController {
        let mainStoryboard =  NSStoryboard(name: "Main", bundle: nil)
        guard let viewcontroller = mainStoryboard.instantiateController(withIdentifier: "WorkspaceViewController") as? WorkspaceViewController else {
            fatalError("Why can't I find WorkspaceViewController? - Check Main.storyboard")
        }
        viewcontroller.delegate = delegate
        return viewcontroller
    }
}

