//
//  DrawingAppTests.swift
//  DrawingAppTests
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import XCTest
@testable import DrawingApp

class DrawingAppTests: XCTestCase {
    
    var plane: Planable!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        plane = Plane()
    }

    override func tearDownWithError() throws {
        plane = nil
        try super.tearDownWithError()
    }
    
    func testAddRectangle() throws {
        // Given
        plane.makeRectangle()
        
        // When
        
        // Then
        XCTAssertNotNil((plane as? Plane)?.rectangles, "A Rectangle didn't be added")
    }
    
    func testCanSubscript() throws {
        // Given
        for _ in 0...3 {
            plane.makeRectangle()
        }
        
        // When
        let suspect: Rectangle.Type = type(of: plane[2])
        
        // Then
        XCTAssert(suspect == Rectangle.self, "잘 가져왔는가요?")
    }
    
    func testCanContainTouchPoint() throws {
        // Given
        let testableRectanle: Rectangle = Rectangle(id: "xxx-xxx-xxx", size: (150.0, 120.0), point: (300.0, 300.0), backgroundColor: (0,0,0), alpha: .one)
        let containedPoint = (350.0, 350.0)
        let unContainedPoint = (550.0, 550.0)
        let planeObject: Plane = plane as! Plane
        
        // When
        planeObject.rectangles.append(testableRectanle)
        
        // Then
        XCTAssertTrue(planeObject.isTouched(at: containedPoint), "터치가 안되었습니다.")
        XCTAssertFalse(planeObject.isTouched(at: unContainedPoint), "터치가 되었습니다.")
    }
}
