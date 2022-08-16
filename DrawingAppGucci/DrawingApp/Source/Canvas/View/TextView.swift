//
//  TextView.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/08/08.
//

import UIKit

class TextView: UILabel, Drawable {
    var index: Int
    
    init(text: Text, index: Int) {
        self.index = index
        
        super.init(frame:
                    CGRect(
                        x: text.point.x,
                        y: text.point.y,
                        width: .zero,
                        height: text.size.height))
        configureAttribute(by: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAlpha(alpha: Alpha) {
        self.textColor = UIColor.label.withAlphaComponent(alpha.value)
    }
    
    func configureAttribute(by text: Text) {
        super.layer.borderColor = tintColor.cgColor
        super.text = text.string
        super.textColor = UIColor.label.withAlphaComponent(text.alpha.value)
        super.font = UIFont(name: "Optima", size:  32)
        super.isUserInteractionEnabled = true
        super.isEnabled = true
        super.sizeToFit()
    }
}
