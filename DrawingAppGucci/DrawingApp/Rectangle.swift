//
//  Rectangle.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import Foundation

final class Rectangle: CustomStringConvertible {
    lazy var description: String = "(\(id)), X\(point.0), Y\(point.1), W\(size.0), H\(size.1) R: \(color.0), G: \(color.1), B: \(color.2), alpha: \(alpha.value)"
        
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
    var red: Double { return Double(color.0) / 255 }
    
    var green: Double { return Double(color.1) / 255 }
    
    var blue: Double { return Double(color.2) / 255 }
    
    var width: Double { return size.0 }
    
    var height: Double { return size.1 }
    
    var x: Double { return point.0 }
    
    var y: Double { return point.1 }
    
    var widthBound: ClosedRange<Double> { return bounds.0 }
    
    var heightBound: ClosedRange<Double> { return bounds.1 }
    
    
    init(id: String, size: (Double, Double), point: (Double, Double), backgroundColor: (UInt8, UInt8, UInt8), alpha: Alpha) {
        self.id = id
        self.size = size
        self.point = point
        self.color = backgroundColor
        self.alpha = alpha
    }
}
