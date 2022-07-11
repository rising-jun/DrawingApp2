//
//  Point.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

final class Point {
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    static func makeRandomPoint() -> Point {
        let x = Double.random(in: 0.0 ... 300)
        let y = Double.random(in: 0.0 ... 300)
        return Point(x: x, y: y)
    }
}
extension Point: CustomStringConvertible {
    var description: String {
        "x:\(String(format: "%.0f", x)), y:\(String(format: "%.0f", y))"
    }
}
