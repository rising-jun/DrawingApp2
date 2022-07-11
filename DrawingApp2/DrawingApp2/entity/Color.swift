//
//  Color.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

final class Color {
    var r: Double
    var g: Double
    var b: Double
    init(r: Double, g: Double, b: Double) {
        self.r = r
        self.g = g
        self.b = b
    }
    
    static func makeRandomPoint() -> Color {
        let r = Double.random(in: 0.0 ... 255)
        let g = Double.random(in: 0.0 ... 255)
        let b = Double.random(in: 0.0 ... 255)
        return Color(r: r, g: g, b: b)
    }
}
