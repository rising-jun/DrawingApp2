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
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    
    @IBAction func addRectangleTouched(_ sender: Any) {
        addRectangleView(rect: plane.makeRectangle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        for _ in 0...100 {
            addRectangleView(rect: plane.makeRectangle())
        }
    }
    
    private func attribute() {
        statusView.isHidden = true
        rectangleButton.isOpaque = true
        rectangleButton.layer.cornerRadius = 10
    } 
    
    private func layout() {
        self.view.bringSubviewToFront(rectangleButton)
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
        self.view.bringSubviewToFront(rectangleButton)
    }
    
}



