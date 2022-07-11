//
//  Plane.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/08.
//

import Foundation

protocol Planable {
    func makeRectangle() -> Rectangle
    func isTouched(at point: (Double, Double)) -> Int?
    func findTouchedRectangle(at point: (Double, Double)) -> Rectangle?
    subscript(_ index: Int) -> Rectangle { get }
}

final class Plane: Planable {

    private(set) var rectangles: [Rectangle] = []
    private let factory = Factory()
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
    
    //TODO: - 실패했을 때 값 전달할 방법 리펙토링
    func isTouched(at point: (Double, Double)) -> Int? {
        for (index, rectangle) in rectangles.enumerated() {
            if rectangle.widthBound.contains(point.0)
                && rectangle.heightBound.contains(point.1) {
                return index
            }
        }
        return nil
    }
    
    func findTouchedRectangle(at point: (Double, Double)) -> Rectangle? {
        guard let touchResultIndex = isTouched(at: point) else { return nil }
        return rectangles[touchResultIndex]
    }
}
