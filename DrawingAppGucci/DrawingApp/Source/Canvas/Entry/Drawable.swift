//
//  Drawable.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/25.
//

import Foundation
import UIKit

enum Drawing {
    case rectangle
    case photo
}

protocol Drawable {
    
    var index: Int { get set }
    
//    func drawEdges(selected: Bool) { }
//
//    func updateColorAndAlpha(color: Color, alpha: Alpha) { }
//
//    init(index: Int) {
//        self.index = index
//    }
}

//extension Drawable: Equatable {
//    static func ==(lhs: Drawable, rhs: Drawable) -> Bool {
//        return lhs.index == rhs.index
//    }
//}
