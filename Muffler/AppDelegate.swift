//
//  AppDelegate.swift
//  Muffler
//
//  Created by Daniel Eden on 07/12/2020.
//

import Cocoa
import SwiftUI

enum MuteKind {
  case video, audio
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem!
  var statusItemMenu: NSMenu!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    var image: NSImage
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    if #available(OSX 11.0, *) {
      image = NSImage(systemSymbolName: "mic.slash.fill", accessibilityDescription: "Mute Video or Microphone")!
    } else {
      image = NSImage(named: "mic")!
    }
    
    statusItem.button?.image = image

    statusItemMenu = .init()
    statusItemMenu.addItem(NSMenuItem(title: "Mute/Toggle Microphone", action: #selector(toggleMuteMic), keyEquivalent: "A"))
    statusItemMenu.addItem(NSMenuItem(title: "Stop/Toggle Video", action: #selector(toggleMuteVideo), keyEquivalent: "V"))
    statusItemMenu.addItem(NSMenuItem.separator())
    statusItemMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q"))
    statusItem?.menu = statusItemMenu
  }
  
  @objc func quitApp(_ sender: Any?) {
    NSApplication.shared.terminate(self)
  }
  
  func toggleMute(ofKind muteKind: MuteKind) {
    var bluejeansKey: String
    var verb: [String]
    var noun: String
    var zoomMenuItemTitles: [String]
    
    switch muteKind {
    case .audio:
      bluejeansKey = "m"
      verb = ["Muted", "Unmuted"]
      noun = "audio"
      zoomMenuItemTitles = ["Mute Audio", "Unmute Audio"]
    case .video:
      bluejeansKey = "v"
      verb = ["Stopped", "Started"]
      noun = "video"
      zoomMenuItemTitles = ["Stop Video", "Start Video"]
    }
    
    let script = NSAppleScript(source: """
    set bluejeans to "BlueJeans"
    set zoomus to "zoom.us"
    set toggledMute to false

    tell application "System Events"
      set activeApp to name of first application process whose frontmost is true
    end tell

    if application bluejeans is running then
      tell application "System Events"
        if (exists process bluejeans) then
          if not frontmost of process bluejeans then
            set frontmost of process bluejeans to true
          end if
          keystroke "\(bluejeansKey)"
          set frontmost of process activeApp to true
          
          display notification "Toggled \(noun) mute for BlueJeans"
          set toggledMute to true
        end if
      end tell
    end if

    if application zoomus is running then
      tell application "System Events" to tell process zoomus
        if menu item "\(zoomMenuItemTitles[1])" of menu 1 of menu bar item "Meeting" of menu bar 1 exists then
          click menu item "\(zoomMenuItemTitles[1])" of menu 1 of menu bar item "Meeting" of menu bar 1
          set verb to "\(verb[1])"
        else if menu item "\(zoomMenuItemTitles[0])" of menu 1 of menu bar item "Meeting" of menu bar 1 exists then
          click menu item "\(zoomMenuItemTitles[0])" of menu 1 of menu bar item "Meeting" of menu bar 1
          set verb to "\(verb[0])"
        end if
        
        display notification verb & " \(noun) on Zoom"
        set toggledMute to true
      end tell
    end if

    if toggledMute is false then
      display notification "No mutable application found"
    end if
    """)
    
    var error: NSDictionary?
    if let returnDescription = script?.executeAndReturnError(&error).stringValue {
      print(returnDescription)
    } else if error != nil {
      print(error?.description ?? "Error")
    }
  }
  
  @objc func toggleMuteMic(_ sender: Any?) {
    toggleMute(ofKind: .audio)
  }
  
  @objc func toggleMuteVideo(_ sender: Any?) {
    toggleMute(ofKind: .video)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

