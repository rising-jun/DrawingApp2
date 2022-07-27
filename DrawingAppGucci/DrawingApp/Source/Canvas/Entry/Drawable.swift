//
//  Drawable.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/25.
//

import Foundation

// MARK: - SquareView 와 PhotoView 에 index 속성을 부여하고, 형변환이 가능하게 하는 프로토콜
protocol Drawable {
    var index: Int { get set }
}
