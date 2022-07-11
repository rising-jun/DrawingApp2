//
//  Factory.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import Foundation

final class Factory {
    func generateRectangle() -> Rectangle {
        let uuid = makeUUID()
        let width: Double = 150.0
        let height: Double = 120.0
        let rgb: (UInt8, UInt8, UInt8) = (UInt8.random(in: UInt8.min...UInt8.max),
                                          UInt8.random(in: UInt8.min...UInt8.max),
                                          UInt8.random(in: UInt8.min...UInt8.max))
        let point: (Double, Double) = (Double.random(in: 0...ScreenSize.width), Double.random(in: 0...ScreenSize.height))
        let alpha: Alpha = makeAlpha()
        
        return Rectangle(id: uuid, size: (width, height), point: point, backgroundColor: rgb, alpha: alpha)
    }
    
     private func makeUUID() -> String {
        let id = UUID()
            .uuidString
            .components(separatedBy: "-")
            .reduce("") { partialResult, word in
                return partialResult + word
            }
        
        var resultId: String = ""
        for word in id.enumerated() {
            if word.offset > 8 {
                break
            }
            if word.offset % 3 == 0 && word.offset != 0 {
                resultId += "-"
            }
            resultId += String(word.element)
        }

        return resultId
    }
    
    private func makeAlpha() -> Alpha {
        let randomAlpha = Int.random(in: 1...10)
        switch randomAlpha {
        case 1:
            return .one
        case 2:
            return .two
        case 3:
            return .three
        case 4:
            return .four
        case 5:
            return .five
        case 6:
            return .six
        case 7:
            return .seven
        case 8:
            return .eight
        case 9:
            return .nine
        default:
            return .ten
        }
    }
}
