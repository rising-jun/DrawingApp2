//
//  Shape.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/27.
//

import Foundation

class Shape: NSObject {
    
    var id: String
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
    
    
    required init?(coder: NSCoder) {
        guard let tempId = coder.decodeObject(forKey: "id") as? String
        else { assert(false) }
        
        let height = coder.decodeDouble(forKey: "height")
        let x = coder.decodeDouble(forKey: "x")
        let y = coder.decodeDouble(forKey: "y")
        let alphaValue = coder.decodeDouble(forKey: "alpha")
        let width = coder.decodeDouble(forKey: "width")
        var tempAlpha = ShapeFactory.generateAlpha()
        tempAlpha.change(value: alphaValue)
        
        self.id = tempId
        let size = Size(width: width, height: height)
        let point = Point(x: x, y: y)
        self.size = size
        self.point = point
        self.alpha = tempAlpha
        self.bound = Bound(size: size, point: point)
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

extension Shape: NSCoding {
    func encode(with coder: NSCoder) {
        
        coder.encode(size.height, forKey: "height")
        coder.encode(size.width, forKey: "width")
        coder.encode(point.x, forKey: "x")
        coder.encode(point.y, forKey: "y")
        coder.encode(alpha.value, forKey: "alpha")
        coder.encode(id, forKey: "id")
    }
}
