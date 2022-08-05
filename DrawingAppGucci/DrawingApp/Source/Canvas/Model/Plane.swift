//
//  Plane.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/08.
//

import Foundation

protocol Planable {
    func makeShape(with blueprint: ShapeBlueprint, image data: Data?)
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
        precondition(isIndexValid(index: index), "shapes is out of index")
        return self.shapes[index]
    }
    
    private func isIndexValid(index: Int) -> Bool {
        return 0 <= index && index < self.shapes.count
    }

    func makeShape(with blueprint: ShapeBlueprint, image data: Data? = nil) {
        
        let isRectangle: Bool = blueprint == .rectangle
        let notiName: Notification.Name = isRectangle ? .rectangle : .photo
        let notiKey: NotificationKey = isRectangle ? .rectangle : .photo
        
        let shape = factory.generateShape(with: blueprint, imageData: data)
        shapes.append(shape)
        
        NotificationCenter.default
            .post(
                name: notiName,
                object: self,
                userInfo: [notiKey: shape,
                           NotificationKey.index: count - 1]
            )
    }
    
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

// MARK: - 사각형이나 사진의 위치, 크기를 조정
extension Plane {
    func renewCenterOfShape(at index: Int, after position: Point) {
        let touchedShape = self[index] 
        touchedShape.movePlace(to: position)
        
        NotificationCenter.default.post(name: .move, object: self)
    }
    
    func adjustWidth(index: Int, isUp: Bool) {
        let shape = self[index]
        shape.adjustWidth(isUp: isUp)
        postPropertiesNotification(notiName: .width, isUp: isUp)
    }
    
    func adjustHeight(index: Int, isUp: Bool) {
        let shape = self[index]
        shape.adjustHeight(isUp: isUp)
        postPropertiesNotification(notiName: .height, isUp: isUp)
    }
    
    func adjustX(index: Int, isUp: Bool) {
        let shape = self[index]
        shape.adjustX(isUp: isUp)
        postPropertiesNotification(notiName: .x, isUp: isUp)
    }
    
    func adjustY(index: Int, isUp: Bool) {
        let shape = self[index]
        shape.adjustY(isUp: isUp)
        postPropertiesNotification(notiName: .y, isUp: isUp)
    }
    
    private func postPropertiesNotification(notiName: Notification.Name, isUp: Bool) {
        NotificationCenter.default.post(name: notiName, object: self, userInfo: [NotificationKey.isUp: isUp])
    }
}


// 이게그러니까 노티를 여기서 날리면 저기서 어떤 기준으로 받을 건지에 대한 이야기..크기와 위치 정보를 나누는 것 정도는 괜찮아 보인다 .
//근데 그렇게 처리를 했을 떄, VC에서 할일은 무엇인가> ?
//1. 해당 뷰의 인덱스를 이용해서 실제 view 의 크기나 위치를 업데이트 하는 것
//2. 상태알림창에 필요한 정보을 올리고 그 상태 창에서는 변경된 데이터에 값을 업데이트 하는 것
//
// 노티에 담을 요소
// 몇번 째 view인지를 나타내는 인덱스와 변경된 사항에 대한 값을 넘겨주어야 한다. 변경된 사항만을 넘길 것이냐 전체 shape 를 넘길 것이냐 .아니다 넘길 필요도 없다.
// 상태알림창에서 변경이 일어나는 것은 label 하나다.
// 그러므로 기존에 가지고 있는 값에서 +- 1 정도만 하면 되지 값도 넘길 필요가 없다. 해당 요소를 업데이트하라는 신호를 넘기면 된다.
// 예
// 노티 종류 - width, 노티 키 up, 노티키 인덱스
// 노티 종류 - height, 노티 키 down, 노티키 인덱스
// 노티 종류 - x, 노티 키 down, 노티키 인덱스
// 노티 종류 - y, 노티 키 up, 노티키 인덱스
