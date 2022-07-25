//
//  Plane.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/08.
//

import Foundation

protocol Planable {
    
    func makeRectangle()
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
    
    func makeRectangle() {
        let rectangle = factory.generateRectangle()
        rectangles.append(rectangle)
        NotificationCenter.default.post(name: .rectangle, object: self, userInfo: [NotificationKey.rectangle: rectangle])
    }
    
    func isTouched(at point: (Double, Double)) -> Int? {
        for (index, rectangle) in rectangles.enumerated() {
            if rectangle.bound.xBound.contains(point.0)
                && rectangle.bound.yBound.contains(point.1) {
                return index
            }
        }
        return nil
    }
    
    func findTouchedRectangle(at point: (Double, Double)) -> Rectangle? {
        guard let touchResultIndex = isTouched(at: point) else { return nil }
        return rectangles[touchResultIndex]
    }
    
    func changeColor(for rectangle: Rectangle) {
        rectangle.setRandomColor()
        NotificationCenter.default.post(name: .color, object: self, userInfo: [NotificationKey.color: rectangle.color.hexaColor])
    }
    
    func changeAlpha(for rectangle: Rectangle, value: Double) {
        let roundedAlpha: Double = round(value * 10) / 10
        rectangle.changeAlpha(value: roundedAlpha)
        //MARK: - roundedAlpha 에서 +- 0.1 된 값이 넘겨질 것임
        NotificationCenter.default.post(name: .alpha, object: self, userInfo: [NotificationKey.alpha: rectangle.alpha.value])
    }
}
