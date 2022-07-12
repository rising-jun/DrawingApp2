//
//  ViewController.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import UIKit
import os.log

final class CanvasViewController: UIViewController {
    
    private let plane = Plane()
    private var beforeSelectedView: SquareView? {
        didSet {
            // TODO: - Status View 한테 새로운 렉탱글이 왔다고 알려야함(뷰를 구분한다면 말이죠!)
            guard oldValue != beforeSelectedView else { return }
            oldValue?.isSelected = false
        }
        
        willSet {
            newValue?.isSelected = true
        }
    }
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBAction func touchedColorButton(_ sender: UIButton) {
        guard let currentSquare = beforeSelectedView,
              let currentRectangle = currentSquare.rectangle
            else { return }
        plane.changeColor(for: currentRectangle)
        currentSquare.updateViewAttribute()
        colorButton.setTitle("\(currentRectangle.hexaColor)", for: .normal)
    }
    @IBOutlet weak var alphaLabel: UILabel!

    @IBOutlet weak var stepper: UIStepper!
    @IBAction func touchedStepper(_ sender: UIStepper) {
        guard let currentSquare = beforeSelectedView else { return }
        sender.value = round(sender.value * 10) / 10
        slider.value = Float(sender.value)
        plane.changeAlpha(for: currentSquare.rectangle, value: sender.value)
        currentSquare.updateViewAttribute()
    }
    
    @IBAction func movedDot(_ sender: UISlider) {
        guard let currentSquare = beforeSelectedView else { return }
        let roundedSliderValue: Float = round(sender.value * 10) / 10
        sender.value = roundedSliderValue
        stepper.value = Double(roundedSliderValue)
        stepper.value = round(stepper.value * 10) / 10
        plane.changeAlpha(for: currentSquare.rectangle, value: stepper.value)
        currentSquare.updateViewAttribute()
    }
    
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    
    @IBAction func touchedRectangleButton(_ sender: Any) {
        addRectangleView(rect: plane.makeRectangle())
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.view)
        guard let selectedRectangleIndex = plane.isTouched(at: (Double(point.x), Double(point.y))) else {
            statusView.isHidden = true
            beforeSelectedView = nil
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
        informSelectedViewToStatus(with: selectedView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
    }
    
    private func attribute() {
        statusView.isHidden = true
        colorLabel.text = "색상"
        colorButton.setTitle("#123456", for: .normal)
        alphaLabel.text = "투명도"
        rectangleButton.isOpaque = true
        rectangleButton.layer.cornerRadius = 10
        slider.isContinuous = false
        slider.minimumValue = 0.1
        slider.maximumValue = 1.0
        stepper.isContinuous = false
        stepper.minimumValue = 0.1
        stepper.maximumValue = 1.0
        stepper.stepValue = 0.1
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

extension CanvasViewController {
    private func informSelectedViewToStatus(with square: SquareView) {
        guard let rectangle = square.rectangle else { return }
        statusView.isHidden = false
        colorButton.setTitle("\(rectangle.hexaColor)", for: .normal)
        slider.value = Float(rectangle.alpha.value)
        stepper.value = rectangle.alpha.value
    }
}
