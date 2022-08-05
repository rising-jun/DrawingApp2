//
//  Shape.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/27.
//

import Foundation

class Shape {
    
    let id: String
    var size: Size {
        didSet {
            self.bound = Bound(size: self.size, point: self.point)
        }
    }
    var point: Point {
        didSet {
            self.bound = Bound(size: self.size, point: self.point)
        }
    }
    
    private(set) var alpha: Alpha
    private(set) var bound: Bound

    init(id: String, size: Size, point: Point, alpha: Alpha, bound: Bound) {
        self.id = id
        self.size = size
        self.point = point
        self.alpha = alpha
        self.bound = bound
    }
    
    func changeAlpha(value: Double) {
        self.alpha.change(value: value)
    }
    
    func movePlace(to point: Point) {
        self.point.x = point.x
        self.point.y = point.y
    }
    
    func adjustWidth(isUp: Bool) {
        self.size.width += isUp ? 1 : -1
    }
    
    func adjustHeight(isUp: Bool) {
        self.size.height += isUp ? 1 : -1
    }
    
    func adjustX(isUp: Bool) {
        self.point.x += isUp ? 1 : -1
    }
    
    func adjustY(isUp: Bool) {
        self.point.y += isUp ? 1 : -1
    }
}
