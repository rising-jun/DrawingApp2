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
    static let move = Notification.Name("Shape의 Center 값이 변경되었습니다.")
    static let x = Notification.Name("X 위치 조정")
    static let y = Notification.Name("Y 위치 조정")
    static let width = Notification.Name("width 크기 조정")
    static let height = Notification.Name("height 크기 조정")
}

enum NotificationKey {
    case alpha
    case color
    case index
    case shape
    case blueprint
}

