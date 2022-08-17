//
//  VCNotificationExtension.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/08/16.
//

import UIKit

extension CanvasViewController {
    
    // MARK: - 노티피케이션 옵저버 등록
    func addObservers() {
        
        // MARK: - 크기와 위치에 관련한 노티피케이션
        NotificationCenter.default.addObserver(
            forName: .property,
            object: nil,
            queue: .main) { [unowned self] noti in
                guard
                    let drawbleView = beforeSelectedView as? Drawable,
                    let currentView = beforeSelectedView,
                    let someProtperty = noti.userInfo?[NotificationKey.property] as? ShapeProperty
                else { return }
                let shape = plane[drawbleView.index]
                switch someProtperty {
                case .x:
                    currentView.layer.frame.origin.x = shape.point.x
                case .y:
                    currentView.layer.frame.origin.y = shape.point.y
                case .width, .height:
                    currentView.frame = CGRect(
                        x: shape.point.x,
                        y: shape.point.y,
                        width: shape.size.width,
                        height: shape.size.height)
                }
                updatePropertiesLabels(with: currentView)
            }
        
        //MARK: - 도형 투명도 변경
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

        //MARK: - 도형 추가
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
}
