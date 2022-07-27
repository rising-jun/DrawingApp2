//
//  Plane.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/08.
//

import Foundation

protocol Planable {
    func makeShape(with blueprint: BlueprintOfViewShape)
    func isTouched(at point: (Double, Double)) -> Int?
    func findTouchedShape(at point: (Double, Double)) -> Shape?
    func changeColor(at index: Int)
    func changeAlpha(at index: Int, value: Double)
    subscript(_ index: Int) -> Shape { get }
}

final class Plane: Planable {
    
    //MARK: - photo가 rectangle을 상속받음
    private(set) var shapes: [Shape] = []
    private let factory = ShapeFactory()
    var count: Int { shapes.count }
    
    subscript(index: Int) -> Shape {
        //MARK: - Debug == assert, release == precondition
        assert(isIndexValid(index: index), "out of index")
        return self.shapes[index]
    }
    
    private func isIndexValid(index: Int) -> Bool {
        return 0 <= index && index < self.shapes.count
    }

    func makeShape(with blueprint: BlueprintOfViewShape) {
        
        let isRectangle: Bool = blueprint == .rectangle
        let notiName: Notification.Name = isRectangle ? .rectangle : .photo
        let notiKey: NotificationKey = isRectangle ? .rectangle : .photo
        let shape = factory.generateShape(with: blueprint)
        shapes.append(shape)
        NotificationCenter.default
            .post(
                name: notiName,
                object: self,
                userInfo: [notiKey: shape,
                           NotificationKey.index: count - 1]
            )
    }
    
    // TODO: -  CanvasVC 에서 어떻게 쓰이는 지 확인 1
    // MARK: - 몇 번째 인덱스가 선택되었는지 반환
    func isTouched(at point: (Double, Double)) -> Int? {
        for (index, rectangle) in shapes.enumerated() {
            if rectangle.bound.xBound.contains(point.0)
                && rectangle.bound.yBound.contains(point.1) {
                return index
            }
        }
        return nil
    }
    
    // TODO: -  CanvasVC 에서 어떻게 쓰이는 지 확인 2
    // MARK: - 선택된 인덱스의 사각형을 반환
    func findTouchedShape(at point: (Double, Double)) -> Shape? {
        guard let touchResultIndex = isTouched(at: point) else { return nil }
        return self[touchResultIndex]
    }
    
    //MARK: - 색상 변경
    func changeColor(at index: Int) {
        guard let rectangle = self[index] as? Rectangle else { return }
        rectangle.setRandomColor()

        NotificationCenter.default
            .post(
                name: .rectangle,
                object: self,
                userInfo: [NotificationKey.color: rectangle.color,
                           NotificationKey.alpha: rectangle.alpha]
            )
    }

    /// - roundedAlpha 에서 +- 0.1 된 값이 넘겨질 것임
    //MARK: - 투명도 변경
    func changeAlpha(at index: Int, value: Double) {
        let roundedAlpha: Double = round(value * 10) / 10
        let shape = self[index]
        shape.changeAlpha(value: roundedAlpha)
        
        if let rectangle = shape as? Rectangle {
            NotificationCenter.default
                .post(
                    name: .rectangle,
                    object: self,
                    userInfo: [NotificationKey.color: rectangle.color,
                               NotificationKey.alpha: shape.alpha]
                )
        } else {
            NotificationCenter.default
                .post(
                    name: .photo,
                    object: self,
                    userInfo: [NotificationKey.color: Color.init(r: 0, g: 0, b: 0),
                               NotificationKey.alpha: shape.alpha]
                )
        }
    }
}
