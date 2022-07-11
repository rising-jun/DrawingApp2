//
//  ViewController.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

import UIKit
import OSLog

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rectangleFactory = RectangleFactory()
        for i in 0 ..< 4 {
            let rectangle = rectangleFactory.makeRectangle()
            os_log("%@", "\(rectangle)")
        }
    }
}
