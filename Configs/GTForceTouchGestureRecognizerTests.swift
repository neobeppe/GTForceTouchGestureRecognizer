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
    var forceTouchGestureRecognizer = GTForceTouchGestureRecognizer(target: mockTarget, action: #selector(MockClass.emptySelector))
    
    override func setUp() {
        super.setUp()
        forceTouchGestureRecognizer = GTForceTouchGestureRecognizer(target: GTForceTouchGestureRecognizerTests.mockTarget, action: #selector(MockClass.emptySelector))
        view.addGestureRecognizer(forceTouchGestureRecognizer)
    }
    
    override func tearDown() {
        view.gestureRecognizers = nil
    }
    
    func testInit() {
        let view = UIView()
        let forceTouchGestureRecognizer = GTForceTouchGestureRecognizer(target: GTForceTouchGestureRecognizerTests.mockTarget, action: #selector(MockClass.emptySelector))
        view.addGestureRecognizer(forceTouchGestureRecognizer)
        XCTAssertNotNil(view.gestureRecognizers)
    }
    
    func testDeepPressed() {
        XCTAssert(forceTouchGestureRecognizer.deepPressedAt == 0, "deepPressedAt should be 0")
        forceTouchGestureRecognizer.deepPressed = true
        XCTAssert(forceTouchGestureRecognizer.deepPressedAt > 0, "deepPressedAt should new be greater than 0")
    }
    
}

class MockClass {
    @objc func emptySelector() { }
}
