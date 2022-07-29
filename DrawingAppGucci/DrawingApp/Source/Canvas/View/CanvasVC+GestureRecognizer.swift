//
//  CanvasVC+GestureRecognizer.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/29.
//

import UIKit

extension CanvasViewController: UIGestureRecognizerDelegate {
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))

        panGesture.minimumNumberOfTouches = 2
        panGesture.maximumNumberOfTouches = 2
        
        targetView.addGestureRecognizer(panGesture)
    }
    
    @objc func panGestureHandler(_ sender: UIPanGestureRecognizer) {
    
        /// 왜 해당 위치에 사각형이 없다고 나오는 이유
        /// 일단 이 PanGesture는 계속 순간적으로 그 값을 계산함
        /// 그래서 End 가 찍혔을 때의 Center 는 view가 최종적으로 이동한 위치의 Center 임
        /// 그러므로 당연히 그 자리엔 도형이 존재한 적이 없으므로, Shape 타입에 함수가 제대로된 위치가 도달하지 못하는 것임
        /// 그렇다면 움직이기 시작할 때의 위치를 기억하거나, 움직이기 시작한 도형의 인덱스를 알고 그 인덱스와 함께 최종 센터위치를 넘기게 되면 같이 사용할 수도 있겠고 방법이야 많을 듯하다. 
        switch sender.state {
        case .began:
            print("Began")
        case .changed:
            sender.view?.alpha = 0.5
            
        case .ended:
            print("end")
            guard let movedView = sender.view else { return }
            sender.view?.alpha = 1.0
            let movedCenter = Point(x: movedView.center.x, y: movedView.center.y)
            self.plane.renewCenterOfShape(at: movedCenter)
        default:
            break
        }
        
        let transition = sender.translation(in: self.view)
        sender.view?.center.x += transition.x
        sender.view?.center.y += transition.y
//        sender.view?.layer.frame.origin.x += transition.x
//        sender.view?.layer.frame.origin.y += transition.y
//        sender.view?.alpha = 0.5
    
        sender.setTranslation(.zero, in: self.view)
        // TODO: Noti를 해당 view의 위치가 변했다는 것을 알려야함
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
//        panGestureRecognizer.state = .ended
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        panGestureRecognizer.state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
//        panGestureRecognizer.state = .changed
    }
}
