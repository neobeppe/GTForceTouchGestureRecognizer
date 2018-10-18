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

import Foundation
import XCTest
@testable import GTForceTouchGestureRecognizer

class GTForceTouchGestureRecognizerTests: XCTestCase {
    
    static let mockTarget = MockClass()
    
    let view = UIView()
    var forceTouchGestureRecognizer = GTForceTouchGestureRecognizer(target: mockTarget, action: #selector(MockClass.mockSelector))
    
    override func setUp() {
        super.setUp()
        forceTouchGestureRecognizer = GTForceTouchGestureRecognizer(target: GTForceTouchGestureRecognizerTests.mockTarget, action: #selector(MockClass.mockSelector))
        view.addGestureRecognizer(forceTouchGestureRecognizer)
    }
    
    override func tearDown() {
        view.gestureRecognizers = nil
    }
    
    func testInit() {
        let view = UIView()
        let forceTouchGestureRecognizer = GTForceTouchGestureRecognizer(target: GTForceTouchGestureRecognizerTests.mockTarget, action: #selector(MockClass.mockSelector))
        view.addGestureRecognizer(forceTouchGestureRecognizer)
        XCTAssertNotNil(view.gestureRecognizers)
    }
    
    func testDeepPressed() {
        XCTAssert(forceTouchGestureRecognizer.deepPressedAt == 0, "deepPressedAt should be 0")
        forceTouchGestureRecognizer.deepPressed = true
        XCTAssert(forceTouchGestureRecognizer.deepPressedAt > 0, "deepPressedAt should new be greater than 0")
    }
    
    func testFailHandleTouch() {
        forceTouchGestureRecognizer.handleTouch(nil)
        XCTAssertFalse(forceTouchGestureRecognizer.deepPressed, "Should not be deepPressed")
    }
    
    func testEndTouch() {
        forceTouchGestureRecognizer.deepPressed = true
        forceTouchGestureRecognizer.handleTouch(EndedTouch())
        XCTAssertTrue(forceTouchGestureRecognizer.deepPressed, "Should be now true")
        XCTAssert(forceTouchGestureRecognizer.state == .ended, "State should be ended")
    }
    
    func testBeganTouch() {
        forceTouchGestureRecognizer.handleTouch(BeganTouch())
        XCTAssertTrue(forceTouchGestureRecognizer.deepPressed, "Should be now true")
        XCTAssert(forceTouchGestureRecognizer.state == .began, "State should be began")
    }
    
    func testSuccessfullTouch() {
        
        forceTouchGestureRecognizer.deepPressed = true
        forceTouchGestureRecognizer.hardTriggerMinTime = 0
        
        forceTouchGestureRecognizer.handleTouch(BeganTouch())
        XCTAssertTrue(forceTouchGestureRecognizer.deepPressed, "Should be now true")
        XCTAssert(forceTouchGestureRecognizer.state == .ended, "State should be began")
        
        guard let target = forceTouchGestureRecognizer.gestureParameters.target as? MockClass else {
            XCTFail("target is not MockClass")
            return
        }
        XCTAssert(target.selected == true, "MockClass has not been selected")
    }
    
    func testTouchBegan() {
        forceTouchGestureRecognizer.deepPressed = true
        forceTouchGestureRecognizer.touchesBegan(Set(arrayLiteral: EndedTouch()), with: UIEvent())
        XCTAssertTrue(forceTouchGestureRecognizer.deepPressed, "Should be now true")
        XCTAssert(forceTouchGestureRecognizer.state == .ended, "State should be ended")
    }
    
    func testTouchMoved() {
        forceTouchGestureRecognizer.deepPressed = true
        forceTouchGestureRecognizer.touchesMoved(Set(arrayLiteral: EndedTouch()), with: UIEvent())
        XCTAssertTrue(forceTouchGestureRecognizer.deepPressed, "Should be now true")
        XCTAssert(forceTouchGestureRecognizer.state == .ended, "State should be ended")
        forceTouchGestureRecognizer.touchesMoved(Set(arrayLiteral: EndedTouch()), with: UIEvent())
        XCTAssertTrue(forceTouchGestureRecognizer.deepPressed, "Should be now true")
        XCTAssert(forceTouchGestureRecognizer.state == .ended, "State should be ended")
    }
    
    func testTouchEnded() {
        forceTouchGestureRecognizer.deepPressed = true
        forceTouchGestureRecognizer.touchesEnded(Set(arrayLiteral: EndedTouch()), with: UIEvent())
        XCTAssertFalse(forceTouchGestureRecognizer.deepPressed, "Should be now false")
        XCTAssert(forceTouchGestureRecognizer.state == .ended, "State should be ended")
    }
    
    func testTouchEndedFailed() {
        forceTouchGestureRecognizer.deepPressed = false
        forceTouchGestureRecognizer.touchesEnded(Set(arrayLiteral: EndedTouch()), with: UIEvent())
        XCTAssertFalse(forceTouchGestureRecognizer.deepPressed, "Should be now false")
        XCTAssert(forceTouchGestureRecognizer.state == .failed, "State should be failed")
    }
    
    func testNilTargetAction() {
        forceTouchGestureRecognizer.deepPressed = true
        forceTouchGestureRecognizer.hardTriggerMinTime = 0
        forceTouchGestureRecognizer.gestureParameters.target = nil
        
        forceTouchGestureRecognizer.handleTouch(BeganTouch())
        XCTAssertTrue(forceTouchGestureRecognizer.deepPressed, "Should be now true")
        XCTAssert(forceTouchGestureRecognizer.state == .ended, "State should be began")
    }
    
}

class MockClass {
    
    var selected: Bool = false
    
    @objc func mockSelector() {
        selected = true
    }
}

class EndedTouch: UITouch {
    
    override var maximumPossibleForce: CGFloat {
        return 1.0
    }
    
    override var force: CGFloat {
        return -1.0
    }
}

class BeganTouch: UITouch {
    
    override var maximumPossibleForce: CGFloat {
        return 1.0
    }
    
    override var force: CGFloat {
        return 1.0
    }
}

class Coso: NSObject {
    
    @objc static func test() {
        
    }
}
