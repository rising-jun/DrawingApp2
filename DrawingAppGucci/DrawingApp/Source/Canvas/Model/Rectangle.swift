//
//  Rectangle.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import Foundation

class Rectangle: CustomStringConvertible {
    lazy var description: String = "(\(id)), X\(point.x), Y\(point.y), W\(size.width), H\(size.height) R: \(color.r), G: \(color.g), B: \(color.b), alpha: \(alpha.value)"
    
    let id: String
    let size: Size
    let point: Point
    
    private(set) var color: Color
    private(set) var alpha: Alpha
    private(set) var bound: Bound
    
    init(id: String, size: Size, point: Point, color: Color, alpha: Alpha, bound: Bound) {
        self.id = id
        self.size = size
        self.point = point
        self.color = color
        self.alpha = alpha
        self.bound = bound
    }
    
    func setRandomColor() {
        self.color.setRandomColor()
    }
    
    func changeAlpha(value: Double) {
        self.alpha.change(value: value)
    }
}
