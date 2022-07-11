//
//  Plane.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/08.
//

import Foundation

protocol Planable {
    func makeRectangle() -> Rectangle
    func isTouched(at point: (Double, Double)) -> (Bool, Int)
    func findTouchedRectangle(at point: (Double, Double)) -> Rectangle?
    subscript(_ index: Int) -> Rectangle { get }
}

final class Plane: Planable {

    var rectangles: [Rectangle] = []
    let factory = Factory()
    var count: Int { rectangles.count }
    
    subscript(index: Int) -> Rectangle {
        //MARK: - Debug == assert, release == precondition
        assert(isIndexValid(index: index), "out of index")
        return self.rectangles[index]
    }
    
    private func isIndexValid(index: Int) -> Bool {
        return 0 <= index && index < self.rectangles.count
    }
    
    func makeRectangle() -> Rectangle {
        let rectangle = factory.generateRectangle()
        rectangles.append(rectangle)
        return rectangle
    }
    
    //TODO: - 리펙토링이 너무 시급해보임. 우짜쓰까잉...
    func isTouched(at point: (Double, Double)) -> (Bool, Int) {
        for (index, rectangle) in rectangles.enumerated() {
            if rectangle.bounds.0.contains(point.0)
                && rectangle.bounds.1.contains(point.1) {
                return (true, index)
            }
        }
        return (false, 999999999)   // 9 아홉개
    }
    
    func findTouchedRectangle(at point: (Double, Double)) -> Rectangle? {
        let touchResult = isTouched(at: point)
        let touchResultBool = touchResult.0
        let touchResultInt = touchResult.1
        return touchResultBool == true ? self[touchResultInt] : nil
    }
}
