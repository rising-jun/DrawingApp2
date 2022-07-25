//
//  ViewController.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import UIKit
import os.log

final class CanvasViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    private let plane = Plane()
    private var beforeSelectedView: SquareView? {
        didSet {
            // TODO: - Status View 한테 새로운 렉탱글이 왔다고 알려야함(뷰를 구분한다면 말이죠!)
            // MARK: - 같은 사각형 뷰를 클릭 하면 리턴되는 가드문
            guard oldValue != beforeSelectedView else { return }
            oldValue?.drawEdges(selected: false)
        }
        
        willSet {
            guard let newValue = newValue else { return }
            newValue.drawEdges(selected: true)
            self.informSelectedViewToStatus(with: newValue)
        }
    }

    @IBAction func touchedColorButton(_ sender: UIButton) {
        guard let currentSquare = beforeSelectedView else { return }
        plane.changeColor(for: currentSquare.rectangle)
    }
    
    @IBAction func touchedStepper(_ sender: UIStepper) {
        guard let currentSquare = beforeSelectedView else { return }
        plane.changeAlpha(for: currentSquare.rectangle, value: sender.value)
    }
    
    @IBAction func movedDot(_ sender: UISlider) {
        guard let currentSquare = beforeSelectedView else { return }
        plane.changeAlpha(for: currentSquare.rectangle, value: Double(sender.value))
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.view)
        guard let selectedRectangleIndex = plane
                .isTouched(at: (Double(point.x), Double(point.y)))
        else {
            statusView.isHidden = true
            beforeSelectedView = nil
            return
        }
        let squareViews: [SquareView] = view
            .subviews
            .compactMap { $0 as? SquareView }
        let selectedView = squareViews[selectedRectangleIndex]
        beforeSelectedView = selectedView
    }
    
    @IBAction func touchedRectangleButton(_ sender: Any) {
        plane.makeRectangle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        bind()
    }
    
    private func attribute() {
        colorLabel.text = "색상"
        alphaLabel.text = "투명도"
        slider.isContinuous = false
        slider.minimumValue = 0.1
        slider.maximumValue = 1.0
        stepper.isContinuous = false
        stepper.minimumValue = 0.1
        stepper.maximumValue = 1.0
        stepper.stepValue = 0.1
        rectangleButton.isOpaque = false
        rectangleButton.layer.cornerRadius = 10
    }
    
    private func layout() {
        statusView.isHidden = true
    }

    private func bind() {

    }
    
    private func setUpNotification() {
        // MARK: - 투명도 조절
        NotificationCenter.default
            .addObserver(
                forName: .alpha,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard let alphaDouble = noti.userInfo?[NotificationKey.alpha] as? Double else { return }
                    
                    self.adjustSliderAndStepper(alphaValue: alphaDouble)
                }
        // MARK: - 색 조절
        NotificationCenter.default
            .addObserver(
                forName: .color,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard let colorString = noti.userInfo?[NotificationKey.color] as? String else { return }
                    
                    self.colorButton.setTitle(colorString, for: .normal)
                    self.beforeSelectedView?.updateViewAttribute()
        }
        NotificationCenter.default
            .addObserver(
                forName: .rectangle,
                object: nil,
                queue: .main) { [unowned self] noti in
            guard let rectangle = noti.userInfo?[NotificationKey.rectangle] as? Rectangle else { return }
                    
            addSquareView(rect: rectangle)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: - 여기에 Notification 을 달아야한다.
        setUpNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - 메인 뷰에 나타나는 요소를 관리하는 메서드
extension CanvasViewController {
    
    private func informSelectedViewToStatus(with square: SquareView) {
        let rectangle = square.rectangle
        statusView.isHidden = false
        colorButton.setTitle(rectangle.color.hexaColor, for: .normal)
        adjustSliderAndStepper(alphaValue: rectangle.alpha.value)
    }
    
    private func addSquareView(rect: Rectangle) {
        let squareView = SquareView(rectangle: rect)
        view.addSubview(squareView)
        view.bringSubviewToFront(rectangleButton)
    }
    
    private func adjustSliderAndStepper(alphaValue: Double) {
        slider.value = Float(alphaValue)
        stepper.value = alphaValue
        self.beforeSelectedView?.updateViewAttribute()
    }
    
}
