//
//  ViewControllExtension.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/08/16.
//

import UIKit

//MARK: - 길게 눌러서 한칸 셀을 움직이는 메서드
extension CanvasViewController {
    func moveViewForward(with index: Int) {
        guard index > 0 else { return }
        let preView = shapeFrameViews[index - 1]
        shapeFrameViews[index - 1] = shapeFrameViews[index]
        shapeFrameViews[index] = preView
    }
    
    func moveViewBackward(with index: Int) {
        guard index < shapeFrameViews.count - 1 else { return }
        let postView = shapeFrameViews[index + 1]
        shapeFrameViews[index + 1] = shapeFrameViews[index]
        shapeFrameViews[index] = postView
    }
}
