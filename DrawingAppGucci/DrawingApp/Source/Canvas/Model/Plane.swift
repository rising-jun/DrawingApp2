//
//  Plane.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/08.
//

import Foundation

protocol Planable {
    
    func makeRectangle()
    func isTouched(at point: (Double, Double)) -> Int?
    func findTouchedRectangle(at point: (Double, Double)) -> Rectangle?
    subscript(_ index: Int) -> Rectangle { get }
}

final class Plane: Planable {
    //MARK: - photo가 rectangle을 상속받음
    private(set) var rectangles: [Rectangle] = []
    private let factory = Factory()
    var count: Int { rectangles.count }
    
    subscript(index: Int) -> Rectangle {
        //MARK: - Debug == assert, release == precondition
        assert(isIndexValid(index: index), "out of index")
        return self.rectangles[index]
    }
    
    private func isIndexValid(index: Int) -> Bool {
        return 0 <= index && index < self.rectangles.count
    }
    
    //MARK: - 사각형 추가
    func makeRectangle() {
        let rectangle = factory.generateRectangle(with: .rectangle)
        rectangles.append(rectangle)
        NotificationCenter.default.post(name: .rectangle, object: self, userInfo: [NotificationKey.rectangle: rectangle, NotificationKey.index: count - 1])
    }
    //MARK: - 사진 추가
    func makePhoto() {
        guard let photo = factory.generateRectangle(with: .photo) as? Photo else { return }
        rectangles.append(photo)
        NotificationCenter.default.post(name: .photo, object: self, userInfo: [NotificationKey.photo: photo,  NotificationKey.index: count - 1])
    }
    
    // MARK: - 몇 번째 인덱스가 선택되었는지 반환
    func isTouched(at point: (Double, Double)) -> Int? {
        for (index, rectangle) in rectangles.enumerated() {
            if rectangle.bound.xBound.contains(point.0)
                && rectangle.bound.yBound.contains(point.1) {
                return index
            }
        }
        return nil
    }
    
    // MARK: - 선택된 인덱스의 사각형을 반환
    func findTouchedRectangle(at point: (Double, Double)) -> Rectangle? {
        guard let touchResultIndex = isTouched(at: point) else { return nil }
        return self[touchResultIndex]
    }
    //MARK: - 색상 변경
    func changeColor(at index: Int) {
        let rectangle = self[index]
        rectangle.setRandomColor()
        if rectangle is Photo {
            NotificationCenter.default.post(name: .photo, object: self, userInfo: [NotificationKey.color: rectangle.color, NotificationKey.alpha: rectangle.alpha])
            return
        }
        NotificationCenter.default.post(name: .rectangle, object: self, userInfo: [NotificationKey.color: rectangle.color, NotificationKey.alpha: rectangle.alpha])
    }
    //MARK: - 투명도 변경
    func changeAlpha(at index: Int, value: Double) {
        let roundedAlpha: Double = round(value * 10) / 10
        let rectangle = self[index]
        rectangle.changeAlpha(value: roundedAlpha)
        if rectangle is Photo {
            NotificationCenter.default.post(name: .photo, object: self, userInfo: [NotificationKey.color: rectangle.color, NotificationKey.alpha: rectangle.alpha])
            return 
        }
        //MARK: - roundedAlpha 에서 +- 0.1 된 값이 넘겨질 것임
        NotificationCenter.default.post(name: .rectangle, object: self, userInfo: [NotificationKey.color: rectangle.color, NotificationKey.alpha: rectangle.alpha])
    }
}
