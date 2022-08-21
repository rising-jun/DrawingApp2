//
//  Photo.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/25.
//

import Foundation

final class Photo: Shape {
    var imageData: Data
    
    init(shape: Shape, urlData: Data) {
        self.imageData = urlData
        super.init(id: shape.id,
                   size: shape.size,
                   point: shape.point,
                   alpha: shape.alpha,
                   bound: shape.bound)
    }
    
    required init?(coder: NSCoder) {
        guard let urlData = coder.decodeObject(forKey: "imageData") as? Data else { assert(false) }
        
        self.imageData = urlData
        super.init(coder: coder)
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(imageData, forKey: "imageData")
    }
}
