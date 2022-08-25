//
//  Bound.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/23.
//

import Foundation

struct Bound {
    let xBound: ClosedRange<Double>
    let yBound: ClosedRange<Double>
    
    init(size: Size, point: Point) {
        self.xBound = point.x...point.x + size.width
        self.yBound = point.y...point.y + size.height
    }
}
