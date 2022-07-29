//
//  Notification +.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/25.
//

import Foundation

extension Notification.Name {
    static let rectangle = Notification.Name("Rectangle이 추가되었습니다.")
    static let photo = Notification.Name("사진이 추가되었습니다.")
    static let color = Notification.Name("컬러값이 변경되었습니다.")
    static let move = Notification.Name("Shape의 Center 값이 변경되었습니다.")
}

enum NotificationKey {
    case rectangle
    case color
    case alpha
    case photo
    case index
}

