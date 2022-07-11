//
//  Size.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

final class Size {
    var height: Double
    var width: Double
    
    init(height: Double = 120 , width: Double = 150) {
        self.height = height
        self.width = width
    }
}
extension Size: CustomStringConvertible {
    var description: String {
        "W\(String(format: "%.0f", width)), H\(String(format: "%.0f", height))"
    }
}
