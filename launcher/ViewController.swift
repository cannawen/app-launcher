//
//  ViewController.swift
//  launcher
//
//  Created by Canna Wen on 2018-01-31.
//  Copyright © 2018 Canna Wen. All rights reserved.
//

import Cocoa

protocol OpenWorkspaceDelegate {
    func didOpenWorkspace()
}

class ViewController: NSViewController {
    var delegate : OpenWorkspaceDelegate!
    
    @IBOutlet weak var chrome: NSButton!
    @IBOutlet weak var iTerm: NSButton!
    @IBOutlet weak var sourcetree: NSButton!
    @IBOutlet weak var sublime: NSButton!
    @IBOutlet weak var android: NSButton!
    @IBOutlet weak var intelliJ: NSButton!
    @IBOutlet weak var xcode: NSButton!
    
    @IBAction func openDevButtonClicked(_ sender: Any) {
        delegate.didOpenWorkspace()
        open(applicationName: "Google Chrome", ifButtonOn: chrome)
        open(applicationName: "iTerm", ifButtonOn: iTerm)
        open(applicationName: "Sourcetree", ifButtonOn: sourcetree)
        open(applicationName: "Sublime Text", ifButtonOn: sublime)
        open(applicationName: "Android Studio", ifButtonOn: android)
        open(applicationName: "IntelliJ IDEA CE", ifButtonOn: intelliJ)
        open(applicationName: "Xcode", ifButtonOn: xcode)
    }
    
    @IBAction func quitButtonClicked(_ sender: Any) {
        NSApp.terminate(self)
    }
    
    func open(applicationName : String, ifButtonOn button : NSButton) {
        if (button.state == NSOnState) {
            openApplication(applicationName: applicationName)
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

extension ViewController {
    static func freshController(delegate: OpenWorkspaceDelegate) -> ViewController {
        guard let viewcontroller = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        viewcontroller.delegate = delegate
        return viewcontroller
    }
}

