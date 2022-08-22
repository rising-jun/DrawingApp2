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
        configureAttribute(by: photo)
    }
    
    deinit {
        self.image = nil
        self.layer.borderColor = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func updateAlphaOrColor(alpha: Alpha, color: Color? = nil) {
        self.alpha = alpha.value
    }
    
    private func configureAttribute(by photo: Photo) {
        self.image = UIImage(data: photo.imageData)
        self.isUserInteractionEnabled = true
        self.layer.borderColor = tintColor.cgColor
        updateAlphaOrColor(alpha: photo.alpha)
    }
}
