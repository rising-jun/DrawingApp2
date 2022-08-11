//
//  Text.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/08/08.
//

import Foundation

final class Text: Shape {
    
    let string: String
    
    init(shape: Shape, string: String) {
        self.string = string
        super.init(id: shape.id, size: shape.size, point: shape.point, alpha: shape.alpha, bound: shape.bound)
    }
}
