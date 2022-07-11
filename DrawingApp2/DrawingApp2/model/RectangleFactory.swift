//
//  RectangleFactory.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

import Foundation

final class RectangleFactory {
    func makeRectangle() -> Rectangle {
        Rectangle(id: Id.makeId(),size: Size(), point: Point.makeRandomPoint(), color: Color.makeRandomPoint(), alpha: Alpha.makeAlpha())
    }
}
