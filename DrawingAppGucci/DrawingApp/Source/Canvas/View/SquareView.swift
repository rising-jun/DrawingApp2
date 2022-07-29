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
        super.init(frame:
                    CGRect(x: rectangle.point.x,
                           y: rectangle.point.y,
                           width: rectangle.size.width,
                           height: rectangle.size.height))

        super.updateColorAndAlpha(color: rectangle.color, alpha: rectangle.alpha)
        //MARK: - 좌상단으로 앵커 포인트 잡기(디폴트 중간)
//        super.layer.anchorPoint = .init(x: 0.0, y: 0.0)
        self.layer.borderColor = tintColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
