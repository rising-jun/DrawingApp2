//
//  VCNotificationExtension.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/08/16.
//

import UIKit

extension CanvasViewController {
    
    // MARK: - 노티피케이션 옵저버 등록
    func coufigureObserverNotifications() {
        
        // MARK: - [GET] 크기와 위치에 관련한 노티피케이션
        NotificationCenter.default.addObserver(
            forName: .property,
            object: nil,
            queue: .main) { [unowned self] noti in
                guard
                    let drawbleView = beforeSelectedView as? Drawable,
                    let currentView = beforeSelectedView,
                    let someProtperty = noti.userInfo?[NotificationKey.property] as? ShapeProperty,
                    let plane = plane
                else { return }
                let shape = plane[drawbleView.index]
                switch someProtperty {
                case .x:
                    currentView.layer.frame.origin.x = shape.point.x
                case .y:
                    currentView.layer.frame.origin.y = shape.point.y
                case .width, .height:
                    currentView.bounds = CGRect(
                        x: shape.point.x,
                        y: shape.point.y,
                        width: shape.size.width,
                        height: shape.size.height)
                }
                updatePropertiesLabels(with: currentView)
            }
        
        //MARK: - [GET] 도형 투명도 변경
        NotificationCenter.default
            .addObserver(
                forName: .color,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard
                        let alpha = noti.userInfo?[NotificationKey.alpha] as? Alpha,
                        let color = noti.userInfo?[NotificationKey.color] as? Color,
                        let blueprint = noti.userInfo?[NotificationKey.blueprint] as? ShapeBlueprint,
                        let drawableView = beforeSelectedView as? Drawable
                    else { return }
                    
                    drawableView.updateAlphaOrColor(alpha: alpha, color: color)
                    self.informSelectedViewToStatus(color: color, alpha: alpha, type: blueprint)
                }

        //MARK: - [GET] 도형 추가
        NotificationCenter.default
            .addObserver(
                forName: .add,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard let shape = noti.userInfo?[NotificationKey.shapeObject] as? Shape,
                          let index = noti.userInfo?[NotificationKey.index] as? Int
                    else {
                        return }
                    
                    self.addView(from: shape, index: index)
                    self.tableView.reloadData()
                }
        
    }
    
    func configurePostNotification() {
        // MARK: - [POST] 배경 뷰의 범위를 알리는 노티피케이션
        var bound:(ClosedRange<Double>, ClosedRange<Double>) {
            let xbound = Double(backgroundView.bounds.minX)...Double(backgroundView.bounds.maxX - ShapeSize.width)
            let ybound = Double(backgroundView.bounds.minY)...Double(backgroundView.bounds.maxY - ShapeSize.height)
            return (xbound, ybound)
        }
        NotificationCenter.default
            .post(
                name: .boundary,
                object: nil,
                userInfo: [NotificationKey.range: bound]
            )
    }
}
