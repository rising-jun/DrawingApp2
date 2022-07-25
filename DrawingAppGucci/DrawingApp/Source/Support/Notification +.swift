//
//  Notification +.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/25.
//

import Foundation

extension Notification.Name {
    static let rectangle = Notification.Name("Rectangle이 추가되었습니다.")
    static let alpha = Notification.Name("알파값이 변경되었습니다.")
    static let color = Notification.Name("컬러값이 변경되었습니다.")
}

enum NotificationKey {
    case rectangle
    case color
    case alpha
}

