//
//  Rectangle.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

final class Rectangle {
    var size: Size
    var point: Point
    var color: Color
    
    init(size: Size, point: Point, color: Color) {
        self.size = size
        self.point = point
        self.color = color
    }
}
