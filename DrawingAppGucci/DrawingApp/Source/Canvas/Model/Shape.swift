//
//  Shape.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/27.
//

import Foundation

class Shape {
    
    let id: String
    let size: Size
    var point: Point
    
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
    
    //TODO: - 이것이 완료되면 VC한테 알려야하는가? 아니면 이미 뷰가 업데이트 되었으므로 알릴 필요가 없는가?
    func movePlace(at point: Point) {
        // point는 센터값이 올것임.
        self.point.x = point.x - 75.0
        self.point.y = point.x - 60.0
    }
}
