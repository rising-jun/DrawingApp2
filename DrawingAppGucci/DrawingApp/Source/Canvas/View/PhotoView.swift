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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func updateImage(image: UIImage) {
        self.image = image
    }
}
