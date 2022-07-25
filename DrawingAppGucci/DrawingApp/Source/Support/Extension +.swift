//
//  Extension +.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/08.
//

import os.log
import UIKit

extension OSLog {
    static var subsystem = Bundle.main.bundleIdentifier!
    
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let model = OSLog(subsystem: subsystem, category: "Model")
}

//MARK: - 이 사이즈를 컴파일 하기 전에 알 수 있나?
enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width - 120.0
    static let height = UIScreen.main.bounds.size.height - 150.0
}

extension UIView {
    func drawEdges(selected: Bool) {
        self.layer.borderWidth = selected ? 10 : 0
    }
    
    func updateColorAndAlpha(color: Color, alpha: Alpha) {
        self.backgroundColor = UIColor.init(red: color.red, green: color.green, blue: color.blue, alpha: alpha.value)
    }
}
