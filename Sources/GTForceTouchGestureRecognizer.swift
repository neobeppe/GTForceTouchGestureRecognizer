/**
 *  GTForceTouchGestureRecognizer
 *
 *  Copyright (c) 2017 Giuseppe Travasoni. Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import UIKit.UIGestureRecognizerSubclass

class GTForceTouchGestureRecognizer: UIGestureRecognizer {
    
    var vibrateOnDeepPress = true
    var threshold: CGFloat = 0.75
    var hardTriggerMinTime: TimeInterval = 0.5
    
    internal var deepPressed: Bool = false {
        willSet {
            if newValue == true {
                deepPressedAt = NSDate.timeIntervalSinceReferenceDate
            }
        }
    }
    internal var deepPressedAt: TimeInterval = 0
    internal var target: AnyObject?
    internal var action: Selector
    internal let feedbackGenerator = UIImpactFeedbackGenerator.init(style: .medium)
    
    required init(target: AnyObject?, action: Selector, threshold: CGFloat = 0.75) {
        self.target = target
        self.threshold = threshold
        self.action = action
        
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        handleTouch(touches.first)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        handleTouch(touches.first)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = deepPressed ? UIGestureRecognizer.State.ended : UIGestureRecognizer.State.failed
        deepPressed = false
    }
    
    internal func handleTouch(_ touch: UITouch?) {
        
        guard view != nil, let touch = touch, touch.force != 0 && touch.maximumPossibleForce != 0 else {
            return
        }
        
        let forcePercentage = touch.force / touch.maximumPossibleForce
        
        if deepPressed && forcePercentage <= 0 {
            endGesture()
            return
        }
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        if !deepPressed && forcePercentage >= threshold {
            vibrate()
            state = UIGestureRecognizer.State.began
            deepPressed = true
            return
        }
        
        if deepPressed && currentTime - deepPressedAt > hardTriggerMinTime && forcePercentage == 1.0 {
            vibrate()
            endGesture()
            if let target = self.target {
                let _ = target.perform(action, with: self)
            }
        }
    }
    
    internal func vibrate() {
        guard vibrateOnDeepPress else {
            return
        }
        feedbackGenerator.impactOccurred()
    }
    
    internal func endGesture() {
        state = UIGestureRecognizer.State.ended
        deepPressed = false
    }
}
