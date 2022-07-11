//
//  Alpha.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

import Foundation

final class Alpha {
    var alpha: Int
    init(alpha: Int){
        self.alpha = alpha
    }
    
    static func makeAlpha() -> Alpha {
        let alpha = Int.random(in: 1 ... 10)
        return Alpha(alpha: alpha)
    }
}
extension Alpha: CustomStringConvertible {
    var description: String {
        "Alpha: \(alpha)"
    }
}
