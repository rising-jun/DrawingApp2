//
//  ViewController.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import UIKit
import Photos
import PhotosUI
import os.log

final class CanvasViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var drawableStackview: UIStackView!
    @IBOutlet weak var pointXView: UIView!
    @IBOutlet weak var pointYView: UIView!
    @IBOutlet weak var sizeWView: UIView!
    @IBOutlet weak var sizeHView: UIView!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    var shapeFrameViews: [UIView] = []
    var plane: Plane {
        guard let plane = SceneDelegate.shared?.plane else { assert(false) }
        return plane
    }
    var beforeSelectedView: UIView? {
        //MARK: - 선택된 뷰의 테두리를 그리고, 이전에 있던 뷰의 테두리를 지우기
        didSet {
            guard let currentView = beforeSelectedView else { return }
            updatePropertiesLabels(with: currentView)
        }
        willSet {
            self.beforeSelectedView?.drawEdges(selected: false)
            newValue?.drawEdges(selected: true)
        }
    }
    
    private let phPickerViewController: PHPickerViewController = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        
        let vc = PHPickerViewController(configuration: config)
        return vc
    }()
    
    @IBAction func touchedRemoveAll(_ sender: Any) {
        SceneDelegate.shared?.plane = Plane()
        removeViews()
        
    }
    @IBAction func touchedTextButton(_ sender: UIButton) {
        plane.makeShape(with: .text)
    }
    
    @IBAction func touchedXUp(_ sender: UIButton) {
        guard let currentView = beforeSelectedView as? Drawable else { return }
        plane.adjustX(index: currentView.index, isUp: true)
    }
    @IBAction func touchedXDown(_ sender: UIButton) {
        guard let currentView = beforeSelectedView as? Drawable else { return }
        plane.adjustX(index: currentView.index, isUp: false)
    }
    @IBAction func touchedYUp(_ sender: UIButton) {
        guard let currentView = beforeSelectedView as? Drawable else { return }
        plane.adjustY(index: currentView.index, isUp: true)
    }
    @IBAction func touchedYDown(_ sender: UIButton) {
        guard let currentView = beforeSelectedView as? Drawable else { return }
        plane.adjustY(index: currentView.index, isUp: false)
    }
    @IBAction func touchedWUp(_ sender: UIButton) {
        guard let currentView = beforeSelectedView as? Drawable else { return }
        plane.adjustWidth(index: currentView.index, isUp: true)
    }
    @IBAction func touchedWDown(_ sender: UIButton) {
        guard let currentView = beforeSelectedView as? Drawable else { return }
        plane.adjustWidth(index: currentView.index, isUp: false)
    }
    @IBAction func touchedHUp(_ sender: UIButton) {
        guard let currentView = beforeSelectedView as? Drawable else { return }
        plane.adjustHeight(index: currentView.index, isUp: true)
    }
    @IBAction func touchedHDown(_ sender: UIButton) {
        guard let currentView = beforeSelectedView as? Drawable else { return }
        plane.adjustHeight(index: currentView.index, isUp: false)
    }
    
    //MARK: - 사진 버튼 누르면 실행 되는 액션
    @IBAction func touchedPictureButton(_ sender: UIButton) {
        present(phPickerViewController, animated: true)
    }
    
    //MARK: - 상태창에 컬러 버튼 누르면 실행 되는 액션
    @IBAction func touchedColorButton(_ sender: UIButton) {
        guard let currentSquare = beforeSelectedView as? Drawable else { return }
        plane.changeColorAndAlpha(at: currentSquare.index, by: nil)
    }
    
    //MARK: - 스테퍼 + - 버튼 누르면 실행 되는 액션
    @IBAction func touchedStepper(_ sender: UIStepper) {
        guard let currentSquare = beforeSelectedView as? Drawable else { return }
        let roundedNumber: Double = round(sender.value * 10) / 10
        plane.changeColorAndAlpha(at: currentSquare.index, by: roundedNumber)

    }
    
    //MARK: - 슬라이더에 점을 움직이면 실행 되는 액션
    @IBAction func movedDot(_ sender: UISlider) {
        guard let currentSquare = beforeSelectedView as? Drawable else { return }
        plane.changeColorAndAlpha(at: currentSquare.index, by: Double(sender.value))
    }
    
    //MARK: - 메인 화면에 한 점을 터치하면 실행되는 액션
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.backgroundView)
//        guard 170.0 <= point.x && point.x <= 950.0 else { return }
        
        sender.cancelsTouchesInView = false
        
        //MARK: - 빈공간인지 아닌지 확인
        guard let index = plane
                .isTouched(at: (Double(point.x), Double(point.y))),
              let selectedShape = plane.findTouchedShape(at: (Double(point.x), Double(point.y)))
        else {
            statusView.isHidden = true
            beforeSelectedView = nil
            return
        }
        
        beforeSelectedView = shapeFrameViews[index]
        
        //MARK: - 상태창에 알림
        if let rectangle = selectedShape as? Rectangle {
            self.informSelectedViewToStatus(color: rectangle.color, alpha: selectedShape.alpha, type: .rectangle)
        } else {
            self.informSelectedViewToStatus(color: Color(), alpha: selectedShape.alpha, type: .photo)
        }
    }
    
    //MARK: - 사각형 버튼 누르면 실행 되는 액션
    @IBAction func touchedRectangleButton(_ sender: UIButton) {
        dump(plane.shapes)
        tableView.reloadData()
        plane.makeShape(with: .rectangle)
    }
    
    //MARK: - 객체들의 초기값 설정
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
        statusView.isHidden = true
        phPickerViewController.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        [pointXView, pointYView, sizeWView, sizeHView].forEach {
            guard let view = $0 else { return }
            view.layer.borderWidth = 0.5
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        drawableStackview.arrangedSubviews.forEach {
            $0.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    
    // MARK: - 메모리 관리를 위해 노티 셋업을 willAppear 에서, 노티 해제를 willDisappear 에서 실행
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coufigureObserverNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configurePostNotification()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
