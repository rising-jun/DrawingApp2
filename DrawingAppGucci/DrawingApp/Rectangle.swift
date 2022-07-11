//
//  Rectangle.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import Foundation

final class Rectangle: CustomStringConvertible {
    lazy var description: String = "(\(id)), X\(point.0), Y\(point.1), W\(size.0), H\(size.1) R: \(color.0), G: \(color.1), B: \(color.2), alpha: \(alpha.rawValue)"
        
    let id: String
    let size: (Double,  Double)
    let point: (Double, Double)
    let color: (UInt8, UInt8, UInt8)
    let alpha: Alpha
    var bounds: (ClosedRange<Double>, ClosedRange<Double>) {
        let widthBound = point.0...point.0 + size.0
        let hegihtBound = point.1...point.1 + size.1
        return (widthBound, hegihtBound)
    }
    
    init(id: String, size: (Double, Double), point: (Double, Double), backgroundColor: (UInt8, UInt8, UInt8), alpha: Alpha) {
        self.id = id
        self.size = size
        self.point = point
        self.color = backgroundColor
        self.alpha = alpha
    }
}
