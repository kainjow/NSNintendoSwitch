//
//  AppDelegate.swift
//  NSNintendoSwitch
//
//  Created by Kevin Wojniak on 10/23/16.
//
//  Copyright (c) 2016 Kevin Wojniak
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var view: LogoView!
    @IBOutlet weak var menuThemeMarketing: NSMenuItem!
    @IBOutlet weak var menuThemeHardware: NSMenuItem!
    @IBOutlet weak var menuitemLoop: NSMenuItem!
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func selectTheme(sender: AnyObject) {
        if let menuitem = sender as? NSMenuItem {
            if menuitem.tag == 0 {
                menuThemeMarketing.state = NSOnState
                menuThemeHardware.state = NSOffState
                view.theme = .Marketing;
            } else {
                menuThemeMarketing.state = NSOffState
                menuThemeHardware.state = NSOnState
                view.theme = .Hardware;
            }
        }
    }
    
    @IBAction func startAnimation(sender: AnyObject) {
        view.animate()
    }
    
    @IBAction func loopAnimation(sender: AnyObject) {
        if menuitemLoop.state == NSOffState {
            view.loop = true
            menuitemLoop.state = NSOnState
        } else {
            view.loop = false
            menuitemLoop.state = NSOffState
        }
    }

}
