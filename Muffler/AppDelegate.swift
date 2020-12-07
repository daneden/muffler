//
//  AppDelegate.swift
//  Muffler
//
//  Created by Daniel Eden on 07/12/2020.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem!
  var statusItemMenu: NSMenu!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let image = NSImage(systemSymbolName: "mic.slash.fill", accessibilityDescription: "Mute Video or Microphone")!
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
  
  @objc func toggleMuteMic(_ sender: Any?) {
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
          keystroke "m"
          set frontmost of process activeApp to true
          
          display notification "Toggled mute for BlueJeans"
          set toggledMute to true
        end if
      end tell
    end if

    if application zoomus is running then
      tell application "System Events" to tell process zoomus
        if menu item "Unmute Audio" of menu 1 of menu bar item "Meeting" of menu bar 1 exists then
          click menu item "Unmute Audio" of menu 1 of menu bar item "Meeting" of menu bar 1
          set verb to "Unmuted"
        else if menu item "Mute Audio" of menu 1 of menu bar item "Meeting" of menu bar 1 exists then
          click menu item "Mute Audio" of menu 1 of menu bar item "Meeting" of menu bar 1
          set verb to "Muted"
        end if
        
        display notification verb & " microphone on Zoom"
        set toggledMute to true
      end tell
    end if
                                   
    set inputVolume to input volume of (get volume settings)
    if inputVolume = 0 then
      set inputVolume to 100
    else
    set inputVolume to 0
      end if
    set volume input volume inputVolume                           

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
  
  @objc func toggleMuteVideo(_ sender: Any?) {
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
          keystroke "v"
          set frontmost of process activeApp to true
          
          display notification "Toggled video for BlueJeans"
          set toggledMute to true
        end if
      end tell
    end if

    if application zoomus is running then
      tell application "System Events" to tell process zoomus
        if menu item "Start Video" of menu 1 of menu bar item "Meeting" of menu bar 1 exists then
          click menu item "Start Video" of menu 1 of menu bar item "Meeting" of menu bar 1
          set verb to "Started"
        else if menu item "Stop Video" of menu 1 of menu bar item "Meeting" of menu bar 1 exists then
          click menu item "Stop Video" of menu 1 of menu bar item "Meeting" of menu bar 1
          set verb to "Stopped"
        end if
        
        display notification verb & " video on Zoom"
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

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

