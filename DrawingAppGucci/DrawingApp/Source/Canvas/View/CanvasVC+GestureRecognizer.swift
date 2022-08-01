//
//  CanvasVC+GestureRecognizer.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/29.
//

import UIKit

extension CanvasViewController: UIGestureRecognizerDelegate {
    
    //MARK: - 뷰가 생성될 때마다 아래 panGesture가 생성되어 gesture recognizer 로 추가 될 것임
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))

        panGesture.minimumNumberOfTouches = 2
        panGesture.maximumNumberOfTouches = 2
        
        targetView.addGestureRecognizer(panGesture)
    }
    
    //MARK: - view를 드래깅 하는 GestureRecognizer
    @objc func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        //MARK: - 움직이기 시작하면 시작점을 "self.initPosition" 에 저장
        case .began:
            guard let origin = sender.view?.frame.origin else { return }
            self.initPostion = Point(x: origin.x, y: origin.y)
        case .changed:
            sender.view?.alpha = 0.5
        //MARK: - 이동이 끝나면, 시작점과 이동점을 Plane에게 넘기고 모델을 재조정 요청
        case .ended:
            guard let changedOrigin = sender.view?.frame.origin,
                  let originPositon = self.initPostion else { return }
            
            let movedPoint = Point(x: changedOrigin.x, y: changedOrigin.y)
            self.plane.renewCenterOfShape(before: originPositon, after: movedPoint)
            sender.view?.alpha = 1.0
        default:
            break
        }
        
        let transition = sender.translation(in: self.view)
        sender.view?.center.x += transition.x
        sender.view?.center.y += transition.y
    
        sender.setTranslation(.zero, in: self.view)
    }
}