//
//  Photo.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/25.
//

import Foundation

final class Photo: Shape {
    var imageURL: URL
    
    init(shape: Shape, url: URL) {
        self.imageURL = url
        super.init(id: shape.id, size: shape.size, point: shape.point, alpha: shape.alpha, bound: shape.bound)
    }
    
    required init?(coder: NSCoder) {
        guard
            let url = coder.decodeObject(forKey: "imageURL") as? URL else { assert(false)}
        self.imageURL = url
        super.init(coder: coder)
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(imageURL, forKey: "imageURL")
    }
}
