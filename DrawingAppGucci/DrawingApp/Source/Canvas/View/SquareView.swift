//
//  SquareView.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/11.
//

import UIKit

final class SquareView: UIView, Drawable {
    
    var index: Int
    
    init(rectangle: Rectangle, index: Int) {
        self.index = index
        super.init(frame: CGRect(x: rectangle.point.x, y: rectangle.point.y, width: rectangle.size.width, height: rectangle.size.height))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
