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
    private let plane = Plane()
    private var image: UIImage?
    private var beforeSelectedView: UIView? {
        didSet {
            // TODO: - Status View 한테 새로운 렉탱글이 왔다고 알려야함(뷰를 구분한다면 말이죠!)
            // MARK: - 같은 사각형 뷰를 클릭 하면 리턴되는 가드문
            guard oldValue != beforeSelectedView else { return }
            oldValue?.drawEdges(selected: false)
        }
        
        willSet {
            guard let newValue = newValue else { return }
            newValue.drawEdges(selected: true)
        }
    }
    
    @IBAction func touchedPictureButton(_ sender: UIButton) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func touchedColorButton(_ sender: UIButton) {
        guard let currentSquare = beforeSelectedView as? Drawable else { return }
        plane.changeColor(at: currentSquare.index)
    }
    
    @IBAction func touchedStepper(_ sender: UIStepper) {
        guard let currentSquare = beforeSelectedView as? Drawable else { return }
        plane.changeAlpha(at: currentSquare.index, value: sender.value)
    }
    
    @IBAction func movedDot(_ sender: UISlider) {
        guard let currentSquare = beforeSelectedView as? Drawable else { return }
        plane.changeAlpha(at: currentSquare.index, value: Double(sender.value))
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
        //MARK: PhotoView와 SquareView 가 한데 들어감
        let squareViews: [UIView] = view.subviews
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
    
    private func setUpNotifications() {
        // MARK: - 사각형 투명도 조절
        NotificationCenter.default
            .addObserver(
                forName: .rectangle,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard
                        let alpha = noti.userInfo?[NotificationKey.alpha] as? Alpha,
                        let color = noti.userInfo?[NotificationKey.color] as? Color
                    else { return }
                    
                    self.adjustSliderAndStepper(color: color, alpha: alpha)
                    self.informSelectedViewToStatus(color: color, alpha: alpha, isPhoto: false)
                }
        // MARK: - 색 조절
        /// 색이 변경된 것이 전파가 되면, 바껴야 할 것들
        /// 1. ColorButton, slider, stepper -> status view 업데이트
        /// 2. beforeSelectedView color 변경
        /// ...
        /// 바꾸려고 하니까 befroeSelected가 squareView만 적용이 되는 문제가 있다.
        /// 그렇다면..?
        /// PhotoView 도 사용할 수 있도록 바꾸어야할 것인데..
        /// DrawingView도 사용할 수 있도록 해볼까?
        /// 해치웠나...?
        NotificationCenter.default
            .addObserver(
                forName: .color,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard
                        let color = noti.userInfo?[NotificationKey.color] as? Color,
                        let alpha = noti.userInfo?[NotificationKey.alpha] as? Alpha
                    else { return }
                    
                    self.beforeSelectedView?.updateColorAndAlpha(color: color, alpha: alpha)
                    self.informSelectedViewToStatus(color: color, alpha: alpha, isPhoto: false)
                }
        
        //MARK: - 사각형 추가
        NotificationCenter.default
            .addObserver(
                forName: .rectangle,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard let rectangle = noti.userInfo?[NotificationKey.rectangle] as? Rectangle,
                          let index = noti.userInfo?[NotificationKey.index] as? Int
                    else { return }
                    
                    self.addSquareView(rect: rectangle, index: index)
                }
        
        //MARK: - 사진 추가
        NotificationCenter.default
            .addObserver(
                forName: .photo,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard let photo = noti.userInfo?[NotificationKey.photo] as? Photo,
                          let index = noti.userInfo?[NotificationKey.index] as? Int,
                    let image = self.image else { return }
                    addPhotoView(photo: photo, image: image, index: index)
                }
        
        //MARK: - 사진 투명도 변경
        NotificationCenter.default
            .addObserver(
                forName: .color,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard
                        let alpha = noti.userInfo?[NotificationKey.alpha] as? Alpha,
                        let color = noti.userInfo?[NotificationKey.color] as? Color
                    else { return }
                    self.adjustSliderAndStepper(color: color, alpha: alpha)
                    self.informSelectedViewToStatus(color: color, alpha: alpha, isPhoto: true)
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - 컬러버튼, 스테퍼, 슬라이더 조정 및 뷰에 사각형, 사진 추가
extension CanvasViewController {
    
    private func informSelectedViewToStatus(color: Color, alpha: Alpha, isPhoto: Bool) {
        
        statusView.isHidden = false
        let buttonTitleString = isPhoto ? "비어있음" : color.hexaColor
        colorButton.setTitle(buttonTitleString, for: .normal)
        adjustSliderAndStepper(color: color, alpha: alpha)
    }
    
    private func addSquareView(rect: Rectangle, index: Int) {
        let squareView = SquareView(rectangle: rect, index: index)
        view.addSubview(squareView)
        view.bringSubviewToFront(drawableStackview)
    }
    
    private func addPhotoView(photo: Photo, image: UIImage, index: Int) {
        let photoView = PhotoView(photo: photo, index: index)
        photoView.image = image
        view.addSubview(photoView)
        view.bringSubviewToFront(drawableStackview)
    }
    
    private func adjustSliderAndStepper(color: Color, alpha: Alpha) {
        slider.value = Float(alpha.value)
        stepper.value = alpha.value
        self.beforeSelectedView?.updateColorAndAlpha(color: color, alpha: alpha)
        
    }
}

// MARK: - 사진 델리게이트
extension CanvasViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                self.image = image
                self.plane.makePhoto()
            }
        }
    }
}
