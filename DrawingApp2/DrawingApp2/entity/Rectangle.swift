//
//  Rectangle.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

final class Rectangle {
    var id: Id
    var size: Size
    var point: Point
    var color: Color
    var alpha: Alpha
    
    init(id: Id, size: Size, point: Point, color: Color, alpha: Alpha) {
        self.id = id
        self.size = size
        self.point = point
        self.color = color
        self.alpha = alpha
    }
}
extension Rectangle: CustomStringConvertible {
    var description: String {
        "\(id.description), \(point.description), \(size.description), \(color.description) \(alpha.description)"
    }
}
