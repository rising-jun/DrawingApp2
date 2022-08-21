//
//  Notification +.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/25.
//

import Foundation

extension Notification.Name {
    static let add = Notification.Name("새로운 오브젝트가 추가되었습니다.")
    static let color = Notification.Name("컬러값이 변경되었습니다.")
    static let property = Notification.Name("프로퍼티 값이 변경되었습니다.")
    static let boundary = Notification.Name("BackgroundView의 범위가 설정되었습니다.")
    static let plane = Notification.Name("플레인의 값이 들어왔습니다. 시작하세요")
}

enum NotificationKey {
    case alpha
    case color
    case index
    case shapeObject
    case blueprint
    case property
    case range
}

