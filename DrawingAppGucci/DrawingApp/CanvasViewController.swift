//
//  ViewController.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import UIKit
import os.log

class CanvasViewController: UIViewController {
    
    private let plane = Plane()
    private var beforeSelectedView: SquareView? {
        didSet {
            // TODO: - Status View 한테 새로운 렉탱글이 왔다고 알려야함
            guard oldValue != beforeSelectedView else { return }
            oldValue?.isSelected = false
        }
        
        willSet {
            newValue?.isSelected = true
        }
    }
    
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    
    @IBAction func touchedRectangleButton(_ sender: Any) {
        addRectangleView(rect: plane.makeRectangle())
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.view)
        guard let selectedRectangleIndex = plane.isTouched(at: (Double(point.x), Double(point.y))) else {
            statusView.isHidden = true
            return
        }
        let squareViews: [UIView] = {
            var array = view.subviews
            array.removeLast()
            array.removeFirst()
            return array
        }()
        
        guard let selectedView = squareViews[selectedRectangleIndex] as? SquareView else {
            return
        }
        self.beforeSelectedView = selectedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
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
        let view = SquareView(rectangle: rect)
        self.view.addSubview(view)
        self.view.bringSubviewToFront(rectangleButton)
    }
    
}
