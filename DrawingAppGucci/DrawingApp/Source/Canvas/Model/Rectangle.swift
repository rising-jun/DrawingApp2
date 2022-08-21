//
//  Rectangle.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import Foundation

final class Rectangle: Shape  {
    //    override var description: String = "(\(id)), X\(point.x), Y\(point.y), W\(size.width), H\(size.height) R: \(color.r), G: \(color.g), B: \(color.b), alpha: \(alpha.value)"
    
    private(set) var color: Color
    
    init(shape: Shape, color: Color) {
        self.color = color
        super.init(id: shape.id, size: shape.size, point: shape.point, alpha: shape.alpha, bound: shape.bound)
    }
    
    required init?(coder: NSCoder) {
        guard
            let r = coder.decodeObject(forKey: "red") as? UInt8,
            let g = coder.decodeObject(forKey: "green") as? UInt8,
            let b = coder.decodeObject(forKey: "blue") as? UInt8
        else { assert(false) }
        color = Color(r: r, g: g, b: b)
        super.init(coder: coder)
    }
    
    func setRandomColor() {
        self.color.setRandomColor()
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(color.r, forKey: "red")
        coder.encode(color.g, forKey: "green")
        coder.encode(color.b, forKey: "blue")
    }
}
