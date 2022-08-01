//
//  PhotoView.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/25.
//

import UIKit

final class PhotoView: UIImageView, Drawable {
    
    var index: Int
    
    init(photo: Photo, index: Int) {
        self.index = index
        super.init(
            frame: CGRect(
                x: photo.point.x,
                y: photo.point.y,
                width: photo.size.width,
                height: photo.size.height)
        )
//        super.isOpaque = false
        super.isUserInteractionEnabled = true
        super.alpha = photo.alpha.value
        
//        super.backgroundColor = UIColor(displayP3Red: .zero, green: .zero, blue: .zero, alpha: photo.alpha.value)
        super.layer.borderColor = tintColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func updateImage(image: UIImage) {
        self.image = image
    }
    
    func updateAlpha(alpha: Alpha) {
        self.alpha = alpha.value
//        self.image = self.image?.withAlpha(alpha.value)
//        self.backgroundColor = UIColor(displayP3Red: .zero, green: .zero, blue: .zero, alpha: alpha.value)
    }
}
