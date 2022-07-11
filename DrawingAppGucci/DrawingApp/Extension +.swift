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

enum ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}
