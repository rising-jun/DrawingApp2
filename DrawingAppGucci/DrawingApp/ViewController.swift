//
//  ViewController.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    private let plane = Plane()
    @IBOutlet weak var statusView: UIView!
    
    @IBAction func addRectangleTouched(_ sender: Any) {
        let rectangle = plane.makeRectangle()
        addRectangleView(rect: rectangle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
    }
    
    private func attribute() {
        statusView.isHidden = true
    }
    
    private func layout() {
        
    }
    
    private func addRectangleView(rect: Rectangle) {
        let view : UIView = {
            let view = UIView()
            view.frame = .init(x: rect.x, y: rect.y, width: rect.width, height: rect.height)
            view.backgroundColor = UIColor.init(red: rect.red,
                                                green: rect.green,
                                                blue: rect.blue,
                                                alpha: rect.alpha.value)
            return view
        }()
        self.view.addSubview(view)
    }
    
}
