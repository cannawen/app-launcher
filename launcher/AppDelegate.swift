//
//  AppDelegate.swift
//  launcher
//
//  Created by Canna Wen on 2018-01-31.
//  Copyright © 2018 Canna Wen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, WorkspaceDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let userDefaults = NSUserDefaultsController.shared().defaults
        
        if (!userDefaults.bool(forKey: "initialized")) {
            initialize(userDefaults: userDefaults)
            userDefaults.setValue(true, forKey: "initialized")
        }
        
        if let button = statusItem.button {
            button.image = NSImage(named:"StatusBarButtonImage")
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = WorkspaceViewController.freshController(delegate: self)
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
    
    func didPerformAction() {
        closePopover(sender: self)
    }
    
    func initialize(userDefaults: UserDefaults) {
        let settingsArray = [
            ["applicationName" : "Google Chrome", "checked" : true],
            ["applicationName" : "iTerm", "checked" : true],
            ["applicationName" : "Sourcetree", "checked" : true],
            ["applicationName" : "Sublime Text", "checked" : false],
            ["applicationName" : "Android Studio", "checked" : false],
            ["applicationName" : "IntelliJ IDEA CE", "checked" : false],
            ["applicationName" : "Xcode", "checked" : false]
        ]
        userDefaults.setValue(settingsArray, forKey: "settingsArray")
    }
}

