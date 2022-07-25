//
//  Photo.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/25.
//

import Foundation

final class Photo: Rectangle {
    
    override init(id: String, size: Size, point: Point, color: Color, alpha: Alpha, bound: Bound) {
        super.init(id: id, size: size, point: point, color: Color(r: 0, g: 0, b: 0), alpha: alpha, bound: bound)
    }
    
    final override func setRandomColor() {
    }
}
