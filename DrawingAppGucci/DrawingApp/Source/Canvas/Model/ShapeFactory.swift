//
//  ShapeFactory.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import Foundation

final class ShapeFactory {
    
    //TODO: - Shape를 먼저 인잇하고 사각형엔 컬러 추가 하는 방식
    func generateShape(with: BlueprintOfViewShape, imageData: Data? = nil) -> Shape {
        let size = Size(width: ShapeSize.width,
                        height: ShapeSize.height)
        let point = Point(x: Double.random(in: 0...ScreenSize.width),
                          y: Double.random(in: 0...ScreenSize.height))
        let shape = Shape(id: generateUUID(),
                          size: size,
                          point: point,
                          alpha: generateAlpha(),
                          bound: Bound(size: size, point: point))

        switch with {
        case .rectangle:
            return Rectangle(shape: shape, color: Color())
        case .photo:
            guard let imageData = imageData else {
                assert(false, "imageData is nil")
            }

            return Photo(shape: shape, imageData: imageData)
        }
        
    }
    
     private func generateUUID() -> String {
        let id = UUID()             // xxxx-xxxx-xxxx-xxxx
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

        return resultId             // xxx-xxx-xxx
    }
    
    private func generateAlpha() -> Alpha {
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
