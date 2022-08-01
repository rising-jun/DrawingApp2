//
//  CanvasVC+GestureRecognizer.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/29.
//

import UIKit

extension CanvasViewController: UIGestureRecognizerDelegate {
    
    //MARK: - 뷰가 생성될 때마다 아래 panGesture가 생성되어 gesture recognizer 로 추가 
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))

        panGesture.minimumNumberOfTouches = 2
        panGesture.maximumNumberOfTouches = 2
        
        targetView.addGestureRecognizer(panGesture)
    }
    
    //MARK: - view를 드래깅 하는 GestureRecognizer
    @objc func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        guard let drawableView = sender.view as? Drawable else { return }
        switch sender.state {
        //MARK: - 움직이기 시작하면 시작점을 "self.initPosition" 에 저장
        case .began:
            fallthrough
        case .changed:
            sender.view?.layer.opacity = 0.5

        //MARK: - 이동이 끝나면, 시작점과 이동점을 Plane에게 넘기고 모델을 재조정 요청
        case .ended:
            guard let changedOrigin = sender.view?.frame.origin else { return }
            
            let movedPoint = Point(x: changedOrigin.x, y: changedOrigin.y)
            self.plane.renewCenterOfShape(at: drawableView.index, after: movedPoint)
            sender.view?.layer.opacity = 1.0
        default:
            break
        }
        
        let transition = sender.translation(in: self.view)
        sender.view?.center.x += transition.x
        sender.view?.center.y += transition.y
    
        sender.setTranslation(.zero, in: self.view)
    }
}
