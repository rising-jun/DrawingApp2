//
//  Color.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

final class Color {
    var r: Int
    var g: Int
    var b: Int
    init(r: Int, g: Int, b: Int) {
        self.r = r
        self.g = g
        self.b = b
    }
    
    static func makeRandomPoint() -> Color {
        let r = Int.random(in: 0 ... 255)
        let g = Int.random(in: 0 ... 255)
        let b = Int.random(in: 0 ... 255)
        return Color(r: r, g: g, b: b)
    }
}
extension Color: CustomStringConvertible {
    var description: String {
        "r:\(r), g:\(g), b:\(b) "
    }
}
