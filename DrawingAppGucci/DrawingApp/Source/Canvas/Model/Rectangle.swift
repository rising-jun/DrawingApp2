//
//  Rectangle.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import Foundation

class Rectangle: Shape, CustomStringConvertible  {
    lazy var description: String = "(\(id)), X\(point.x), Y\(point.y), W\(size.width), H\(size.height) R: \(color.r), G: \(color.g), B: \(color.b), alpha: \(alpha.value)"
   
    
    private(set) var color: Color
    
    init(shape: Shape, color: Color) {
        self.color = color
        super.init(id: shape.id, size: shape.size, point: shape.point, alpha: shape.alpha, bound: shape.bound)
    }
    
    func setRandomColor() {
        self.color.setRandomColor()
    }
}
