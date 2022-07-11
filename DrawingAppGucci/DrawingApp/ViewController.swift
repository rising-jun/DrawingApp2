//
//  ViewController.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import UIKit
import os.log

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        let factory = Factory()
        for index in 1...4 {
            os_log("Rect%@",
                   log: .model,
                   type: .default,
                   "\(index) \(factory.generateRectangle().description)")
        }
    }
    
    
}
