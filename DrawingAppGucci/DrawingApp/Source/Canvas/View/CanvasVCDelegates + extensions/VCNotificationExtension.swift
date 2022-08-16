//
//  VCNotificationExtension.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/08/16.
//

import UIKit

// MARK: - 크기와 위치에 관련한 노티피케이션 설정 추가
// TODO: - 이 메서드 제너럴을 이용해서 줄이는 것 가능한지 따져보기
extension CanvasViewController {
    func setUpPropertiesNotifications() {
        NotificationCenter.default.addObserver(
            forName: .x,
            object: nil,
            queue: .main) { [unowned self] noti in
                guard
                    let drawbleView = beforeSelectedView as? Drawable,
                    let currentView = beforeSelectedView
                else { return }
                let shape = plane[drawbleView.index]
                currentView.layer.frame.origin.x = shape.point.x
                updatePropertiesLabels(with: currentView)
            }
        
        NotificationCenter.default.addObserver(
            forName: .y,
            object: nil,
            queue: .main) { [unowned self] noti in
                guard
                    let drawbleView = beforeSelectedView as? Drawable,
                    let currentView = beforeSelectedView
                else { return }
                let shape = plane[drawbleView.index]
                currentView.layer.frame.origin.y = shape.point.y
                updatePropertiesLabels(with: currentView)
            }
        
        NotificationCenter.default.addObserver(
            forName: .width,
            object: nil,
            queue: .main) { [unowned self] noti in
                guard
                    let drawbleView = beforeSelectedView as? Drawable,
                    let currentView = beforeSelectedView
                else { return }
                let shape = plane[drawbleView.index]
                currentView.frame = CGRect(x: shape.point.x, y: shape.point.y, width: shape.size.width, height: shape.size.height)
                updatePropertiesLabels(with: currentView)
            }
        
        NotificationCenter.default.addObserver(
            forName: .height,
            object: nil,
            queue: .main) { [unowned self] noti in
                guard
                    let drawbleView = beforeSelectedView as? Drawable,
                    let currentView = beforeSelectedView
                else { return }
                let shape = plane[drawbleView.index]
                currentView.frame = CGRect(x: shape.point.x, y: shape.point.y, width: shape.size.width, height: shape.size.height)
                updatePropertiesLabels(with: currentView)
            }
    }
    
    // MARK: - 노티피케이션 옵저버 등록
    func addObservers() {
        
        // TODO: - 아래 3개 메서드를 제너럴을 이용해서 1개의 메서드로 개편
        // MARK: - 사각형 색 및 투명도 조절
        NotificationCenter.default
            .addObserver(
                forName: .rectangle,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard
                        let color = noti.userInfo?[NotificationKey.color] as? Color,
                        let alpha = noti.userInfo?[NotificationKey.alpha] as? Alpha
                    else { return }
                    
                    self.beforeSelectedView?.updateColorAndAlpha(color: color, alpha: alpha)
                    self.informSelectedViewToStatus(color: color, alpha: alpha, type: .rectangle)
                }
        
        //MARK: - 사진 투명도 변경
        NotificationCenter.default
            .addObserver(
                forName: .photo,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard
                        let alpha = noti.userInfo?[NotificationKey.alpha] as? Alpha,
                        let color = noti.userInfo?[NotificationKey.color] as? Color,
                        let photoView = beforeSelectedView as? PhotoView
                    else { return }
                    photoView.updateAlpha(alpha: alpha)
                    self.informSelectedViewToStatus(color: color, alpha: alpha, type: .photo)
                }
        
        //MARK: - 텍스트 투명도 변경
        NotificationCenter.default
            .addObserver(
                forName: .text,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard
                        let alpha = noti.userInfo?[NotificationKey.alpha] as? Alpha,
                        let color = noti.userInfo?[NotificationKey.color] as? Color,
                        let textView = beforeSelectedView as? TextView
                    else { return }
                    textView.updateAlpha(alpha: alpha)
                    self.informSelectedViewToStatus(color: color, alpha: alpha, type: .text)
                }
        
        //MARK: - 도형 추가 알림
        NotificationCenter.default
            .addObserver(
                forName: .add,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard let shape = noti.userInfo?[NotificationKey.shape] as? Shape,
                          let index = noti.userInfo?[NotificationKey.index] as? Int
                    else {
                        return }
                    
                    self.addView(from: shape, index: index)
                    self.tableView.reloadData()
                }
        
        // MARK: - 도형 이동
        NotificationCenter.default.addObserver(forName: .move, object: nil, queue: .main) { _ in
            self.view.reloadInputViews()
        }
    }
}
