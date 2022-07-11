//
//  RectangleFactoryTest.swift
//  DrawingApp2Tests
//
//  Created by 김동준 on 2022/07/11.
//

import XCTest
@testable import DrawingApp2

class RectangleFactoryTest: XCTestCase {

    var rectangleFactory: RectangleFactory!
    
    override func setUpWithError() throws {
        rectangleFactory = RectangleFactory()
    }

    func test_when_rectangle_added() throws {
        let count = 4
        var rectangles = [Rectangle?](repeating: nil, count: count)
        for i in 0 ..< count {
            rectangles[i] = rectangleFactory.makeRectangle()
        }
        
        for i in 0 ..< count {
            guard rectangles[i] != nil else { return XCTFail() }
        }
    }
}
