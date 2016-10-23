//
//  AppDelegate.swift
//  NintendoSwitch
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

}

class LogoView: NSView {

    enum Theme {
        case Marketing
        case Hardware
    }
    
    var theme: Theme = .Marketing {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        let bounds = self.bounds
        
        let backgroundColor: NSColor
        let foregroundColor: NSColor
        
        switch (theme) {
        case .Marketing:
            backgroundColor = NSColor(calibratedRed: 230.0/255.0, green: 0, blue: 18.0/255.0, alpha: 1.0)
            foregroundColor = NSColor.white
            break
        case .Hardware:
            backgroundColor = NSColor(calibratedRed: 112.0/255.0, green: 117.0/255.0, blue: 121.0/255.0, alpha: 1.0)
            foregroundColor = NSColor(calibratedRed: 36.0/255.0, green: 37.0/255.0, blue: 39.0/255.0, alpha: 1.0)
            break
        }
        
        let defaultSize: CGFloat = 200
        let minSize = min(bounds.size.width, bounds.size.height)
        let height: CGFloat = minSize > defaultSize ? defaultSize : minSize
        let width: CGFloat = height // = leftWidth + spacing + rightWidth
        let leftWidth: CGFloat = height * 0.48
        let rightWidth: CGFloat = height * 0.42
        let radius: CGFloat = leftWidth / 2
        let spacing: CGFloat = height / 10
        let knob: CGFloat = height / 5
        let leftKnobY: CGFloat = height * 0.20
        let rightKnobY: CGFloat = height * 0.44
        let leftLineWidth: CGFloat = height / 12.5
        let leftLineWidthHalf: CGFloat = leftLineWidth / 2
        
        let baseX = bounds.origin.x + ceil((bounds.size.width - width) / 2)
        let baseY = NSMaxY(bounds) - ceil((bounds.size.height - height) / 2)
        let leftHeight = height - leftLineWidth
        let leftX = baseX + leftLineWidthHalf
        let leftY = baseY - leftLineWidthHalf
        let leftTrueWidth = leftWidth - leftLineWidth
        let rightX = leftX + leftTrueWidth + leftLineWidthHalf + spacing
        
        // Define path for left controller
        let left = NSBezierPath()
        left.move(to: NSPoint(x: leftX + leftTrueWidth, y: leftY - leftHeight))
        left.line(to: NSPoint(x: leftX + radius, y: leftY - leftHeight))
        left.appendArc(
            from: NSPoint(x: leftX, y: leftY - leftHeight),
            to: NSPoint(x: leftX, y: (leftY - leftHeight) + radius),
            radius: radius
        )
        left.line(to: NSPoint(x: leftX, y: leftY - radius))
        left.appendArc(
            from: NSPoint(x: leftX, y: leftY),
            to: NSPoint(x: leftX + radius, y: leftY),
            radius: radius
        )
        left.line(to: NSPoint(x: leftX + leftTrueWidth, y: leftY))
        left.line(to: NSPoint(x: leftX + leftTrueWidth, y: leftY - leftHeight))
        left.close()
        left.lineWidth = leftLineWidth
        
        // Define path for right controller
        let right = NSBezierPath()
        right.move(to: NSPoint(x: rightX, y: baseY - height))
        right.line(to: NSPoint(x: (rightX + rightWidth) - radius, y: baseY - height))
        right.appendArc(
            from: NSPoint(x: rightX + rightWidth, y: baseY - height),
            to: NSPoint(x: rightX + rightWidth, y: (baseY - height) + radius),
            radius: radius
        )
        right.line(to: NSPoint(x: rightX + rightWidth, y: baseY - radius))
        right.appendArc(
            from: NSPoint(x: rightX + rightWidth, y: baseY),
            to: NSPoint(x: (rightX + rightWidth) - radius, y: baseY),
            radius: radius
        )
        right.line(to: NSPoint(x: rightX, y: baseY))
        right.close()
        
        // Define path for left knob
        let leftKnob = NSBezierPath(ovalIn: NSRect(
            x: leftX + ((leftTrueWidth - knob) / 2),
            y: baseY - (leftKnobY + knob),
            width: knob,
            height: knob
        ))

        // Define path for right knob
        let rightKnob = NSBezierPath(ovalIn: NSRect(
            x: rightX + ((rightWidth - knob) / 2),
            y: baseY - (rightKnobY + knob),
            width: knob,
            height: knob
        ))

        // Draw background
        backgroundColor.set()
        NSBezierPath.fill(bounds)
        
        // Draw controllers
        foregroundColor.set()
        left.stroke()
        right.fill()
        
        // Draw left knob
        leftKnob.fill()
        
        // Draw right knob
        backgroundColor.set()
        rightKnob.fill()
    }
    
}
