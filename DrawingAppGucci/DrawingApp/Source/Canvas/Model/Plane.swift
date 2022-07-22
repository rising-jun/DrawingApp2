//
//  Plane.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/08.
//

import Foundation

protocol Planable {
    var onUpdatedAlpha: (Double) -> Void { get }
    var onUpdatedColor: (String) -> Void { get }
    
    func makeRectangle() -> Rectangle
    func isTouched(at point: (Double, Double)) -> Int?
    func findTouchedRectangle(at point: (Double, Double)) -> Rectangle?
    subscript(_ index: Int) -> Rectangle { get }
}

final class Plane: Planable {

    private(set) var rectangles: [Rectangle] = []
    private let factory = Factory()
    var count: Int { rectangles.count }
    var onUpdatedAlpha: (Double) -> Void = { _ in }
    var onUpdatedColor: (String) -> Void = { _ in }
    
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
        self.onUpdatedColor(rectangle.color.hexaColor)
    }
    
    func changeAlpha(for rectangle: Rectangle, value: Double) {
        let roundedAlpha: Double = round(value * 10) / 10
        rectangle.changeAlpha(value: roundedAlpha)
        //MARK: - roundedAlpha 에서 +- 0.1 된 값이 넘겨질 것임
        self.onUpdatedAlpha(rectangle.alpha.value)
    }
}
