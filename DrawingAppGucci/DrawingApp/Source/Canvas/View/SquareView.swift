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

        self.updateAlphaOrColor(alpha: rectangle.alpha, color: rectangle.color)
        self.layer.borderColor = tintColor.cgColor
    }
    
    deinit {
        self.backgroundColor = .none
        self.layer.backgroundColor = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAlphaOrColor(alpha: Alpha, color: Color?) {
        guard let color = color else { return }

        self.backgroundColor = UIColor.init(red: color.$r, green: color.$g, blue: color.$b, alpha: alpha.value)
    }
}
