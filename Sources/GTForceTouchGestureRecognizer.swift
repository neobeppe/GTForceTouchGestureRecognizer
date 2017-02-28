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

import AudioToolbox
import UIKit.UIGestureRecognizerSubclass

class GTForceTouchGestureRecognizer: UIGestureRecognizer {
    
    var vibrateOnDeepPress = true
    var threshold: CGFloat = 0.75
    var hardTriggerMinTime: TimeInterval = 0.5
    
    private var deepPressed: Bool = false
    private var deepPressedAt: TimeInterval = 0
    private var k_PeakSoundID:UInt32 = 1519
    private var target: AnyObject?
    private var action: Selector
    
    required init(target: AnyObject?, action: Selector, threshold: CGFloat = 0.75)
    {
        self.target = target
        self.threshold = threshold
        self.action = action
        
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent)
    {
        if let touch = touches.first
        {
            handleTouch(touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent)
    {
        if let touch = touches.first
        {
            handleTouch(touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent)
    {
        super.touchesEnded(touches, with: event)
        
        state = deepPressed ? UIGestureRecognizerState.ended : UIGestureRecognizerState.failed
        
        deepPressed = false
    }
    
    private func handleTouch(_ touch: UITouch)
    {
        
        if #available(iOS 9.0, *) {
            
            guard let _ = view, touch.force != 0 && touch.maximumPossibleForce != 0 else { return }
            
            let forcePercentage = (touch.force / touch.maximumPossibleForce)
            
            let currentTime = NSDate.timeIntervalSinceReferenceDate
            
            if !deepPressed && forcePercentage >= threshold
            {
                state = UIGestureRecognizerState.began
                
                if vibrateOnDeepPress
                {
                    AudioServicesPlaySystemSound(k_PeakSoundID)
                }
                
                deepPressedAt = NSDate.timeIntervalSinceReferenceDate
                deepPressed = true
            }
            else if deepPressed && forcePercentage <= 0
            {
                endGesture()
            }
            else if deepPressed && currentTime - deepPressedAt > hardTriggerMinTime && forcePercentage == 1.0
            {
                endGesture()
                
                if vibrateOnDeepPress
                {
                    AudioServicesPlaySystemSound(k_PeakSoundID)
                }
                
                if let target = self.target {
                    let _ = target.perform(action, with: self)
                }
            }
        }
    }
    
    func endGesture() {
        state = UIGestureRecognizerState.ended
        deepPressed = false
    }
}
