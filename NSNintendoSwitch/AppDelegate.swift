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

class LogoView: NSView, NSSoundDelegate {

    enum Theme {
        case Marketing
        case Hardware
    }
    
    var theme: Theme = .Marketing {
        didSet {
            needsDisplay = true
        }
    }
    
    enum AnimationState {
        case None
        case Dropping
        case Raising
    }
    
    var animationState: AnimationState = .None
    
    dynamic var dropProgress: CGFloat = 0 {
        didSet {
            needsDisplay = true
        }
    }
    
    dynamic var raiseProgress: CGFloat = 0 {
        didSet {
            needsDisplay = true
        }
    }
    
    let sound = NSSound(named: "switchClick.notification")!
    
    var loop = false
    
    func animate() {
        if sound.delegate == nil {
            sound.delegate = self
        }
        dropProgress = 0
        raiseProgress = 1
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().duration = 0.15
        NSAnimationContext.current().timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        NSAnimationContext.current().completionHandler = {
            self.sound.play()
            self.animationState = .Raising
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current().duration = 0.3
            NSAnimationContext.current().timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            NSAnimationContext.current().completionHandler = {
                self.animationState = .None
            }
            self.animator().raiseProgress = 0
            NSAnimationContext.endGrouping()
        }
        animationState = .Dropping
        animator().dropProgress = 1
        NSAnimationContext.endGrouping()
    }
    
    override func animation(forKey key: String) -> Any? {
        if (key == "dropProgress" || key == "raiseProgress") {
            return CABasicAnimation()
        }
        return super.animation(forKey: key)
    }
    
    func sound(_ sound: NSSound, didFinishPlaying flag: Bool) {
        if (flag && loop) {
            animate()
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
        
        let height: CGFloat = 200
        let width = height // = leftWidth + spacing + rightWidth
        let leftWidth = height * 0.48
        let rightWidth = height * 0.42
        let radius = leftWidth / 2
        let spacing = height / 10
        let knob = height / 5
        let leftKnobY = height * 0.20
        let rightKnobY = height * 0.44
        let leftLineWidth = height / 12.5
        let leftLineWidthHalf = leftLineWidth / 2
        
        let baseX = bounds.origin.x + ceil((bounds.size.width - width) / 2)
        let baseY = NSMaxY(bounds) - ceil((bounds.size.height - height) / 2)
        let leftHeight = height - leftLineWidth
        let leftX = baseX + leftLineWidthHalf
        let leftTrueWidth = leftWidth - leftLineWidth
        let rightX = leftX + leftTrueWidth + leftLineWidthHalf + spacing
        let rightStartY = baseY + (rightKnobY + (knob / 2))
        let leftY: CGFloat
        let rightY: CGFloat
        
        if animationState == .None || animationState == .Dropping {
            leftY = baseY - leftLineWidthHalf
            rightY = rightStartY - ((rightStartY - baseY) * dropProgress)
        } else {
            let offset = leftLineWidth * raiseProgress
            leftY = baseY - leftLineWidthHalf - offset
            rightY = baseY - offset
        }
        
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
        right.move(to: NSPoint(x: rightX, y: rightY - height))
        right.line(to: NSPoint(x: (rightX + rightWidth) - radius, y: rightY - height))
        right.appendArc(
            from: NSPoint(x: rightX + rightWidth, y: rightY - height),
            to: NSPoint(x: rightX + rightWidth, y: (rightY - height) + radius),
            radius: radius
        )
        right.line(to: NSPoint(x: rightX + rightWidth, y: rightY - radius))
        right.appendArc(
            from: NSPoint(x: rightX + rightWidth, y: rightY),
            to: NSPoint(x: (rightX + rightWidth) - radius, y: rightY),
            radius: radius
        )
        right.line(to: NSPoint(x: rightX, y: rightY))
        right.close()
        
        // Define path for left knob
        let leftKnob = NSBezierPath(ovalIn: NSRect(
            x: leftX + ((leftTrueWidth - knob) / 2),
            y: leftY - (leftKnobY + knob),
            width: knob,
            height: knob
        ))

        // Define path for right knob
        let rightKnob = NSBezierPath(ovalIn: NSRect(
            x: rightX + ((rightWidth - knob) / 2),
            y: rightY - (rightKnobY + knob),
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
