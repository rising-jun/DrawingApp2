//
//  SquareView.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/11.
//

import UIKit

class SquareView: UIView {
    let rectangle: Rectangle!
    
    init(rectangle: Rectangle) {
        self.rectangle = rectangle
        super.init(frame: CGRect(x: rectangle.x,
                                 y: rectangle.y,
                                 width: rectangle.width,
                                 height: rectangle.height))
        self.backgroundColor = UIColor(red: rectangle.red,
                                       green: rectangle.green,
                                       blue: rectangle.blue,
                                       alpha: rectangle.alpha.value)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViewAttribute(rectangle: Rectangle) {
        self.backgroundColor = UIColor(red: rectangle.red,
                                       green: rectangle.green,
                                       blue: rectangle.blue,
                                       alpha: rectangle.alpha.value)
    }
}
