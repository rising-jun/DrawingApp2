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
    internal let plane = Plane()
    internal var initPostion: Point?
    
    private var beforeSelectedView: UIView? {
        //MARK: - 선택된 뷰의 테두리를 그리고, 이전에 있던 뷰의 테두리를 지우기
        didSet {
            guard oldValue != beforeSelectedView else { return }
            oldValue?.drawEdges(selected: false)
        }
        
        willSet {
            guard let newValue = newValue else { return }
            newValue.drawEdges(selected: true)
        }
    }
    
    private let phPickerViewController: PHPickerViewController = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        return vc
    }()
    
    //MARK: - 사진 버튼 누르면 실행 되는 액션
    @IBAction func touchedPictureButton(_ sender: UIButton) {
        present(phPickerViewController, animated: true)
    }
    
    //MARK: - 상태창에 컬러 버튼 누르면 실행 되는 액션
    @IBAction func touchedColorButton(_ sender: UIButton) {
        guard let currentSquare = beforeSelectedView as? Drawable else { return }
        plane.changeColor(at: currentSquare.index)
    }
    
    //MARK: - 스테퍼 + - 버튼 누르면 실행 되는 액션
    @IBAction func touchedStepper(_ sender: UIStepper) {
        guard let currentSquare = beforeSelectedView as? Drawable else { return }
        plane.changeAlpha(at: currentSquare.index, value: sender.value)
    }
    
    //MARK: - 슬라이더에 점을 움직이면 실행 되는 액션
    @IBAction func movedDot(_ sender: UISlider) {
        guard let currentSquare = beforeSelectedView as? Drawable else { return }
        plane.changeAlpha(at: currentSquare.index, value: Double(sender.value))
    }
    
    //MARK: - 메인 화면에 한 점을 터치하면 실행되는 액션
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.view)
        //MARK: - 빈공간인지 아닌지 확인
        guard let index = plane
                .isTouched(at: (Double(point.x), Double(point.y))),
              let selectedShape = plane.findTouchedShape(at: (Double(point.x), Double(point.y)))
        else {
            statusView.isHidden = true
            beforeSelectedView = nil
            return
        }

        //MARK: PhotoView와 SquareView 가 한데 들어감
        let squareViews: [UIView] = view.subviews.filter { $0 is Drawable }
        beforeSelectedView = squareViews[index]
        
        //MARK: - 상태창에 알림
        if let rectangle = selectedShape as? Rectangle {
            self.informSelectedViewToStatus(color: rectangle.color, alpha: selectedShape.alpha, type: .rectangle)
        } else {
            self.informSelectedViewToStatus(color: Color(r: 0, g: 0, b: 0), alpha: selectedShape.alpha, type: .photo)
        }
        
    }
    
    //MARK: - 사각형 버튼 누르면 실행 되는 액션
    @IBAction func touchedRectangleButton(_ sender: Any) {
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
        rectangleButton.layer.cornerRadius = 10
        phPickerViewController.delegate = self

    }
    
    // MARK: - 노티피케이션 옵저버 등록
    private func addObservers() {
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
                    self.informSelectedViewToStatus(color: color, alpha: alpha, type: .rectangle)
                }
        
        // MARK: - 색 조절
        NotificationCenter.default
            .addObserver(
                forName: .rectangle,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard
                        let color = noti.userInfo?[NotificationKey.color] as? Color,
                        let alpha = noti.userInfo?[NotificationKey.alpha] as? Alpha
                    else { return }
                    
                    self.beforeSelectedView?.updateColorAndAlpha(color: color, alpha: alpha)
                    self.informSelectedViewToStatus(color: color, alpha: alpha, type: .rectangle)
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
                          let index = noti.userInfo?[NotificationKey.index] as? Int
                    else { return }
                    addPhotoView(photo: photo, index: index)
                }
        
        //MARK: - 사진 투명도 변경
        NotificationCenter.default
            .addObserver(
                forName: .photo,
                object: nil,
                queue: .main) { [unowned self] noti in
                    guard
                        let alpha = noti.userInfo?[NotificationKey.alpha] as? Alpha,
                        let color = noti.userInfo?[NotificationKey.color] as? Color,
                        let photoView = beforeSelectedView as? PhotoView
                    else { return }
                    photoView.updateAlpha(alpha: alpha)
                    self.adjustSliderAndStepper(color: color, alpha: alpha)
                    self.informSelectedViewToStatus(color: color, alpha: alpha, type: .photo)
                }
        
        // MARK: - 도형 이동
        NotificationCenter.default.addObserver(forName: .move, object: nil, queue: .main) { _ in
            self.view.reloadInputViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    
    // MARK: - 메모리 관리를 위해 노티 셋업을 willAppear 에서, 노티 해제를 willDisappear 에서 실행
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - 컬러버튼, 스테퍼, 슬라이더 조정 및 뷰에 사각형, 사진 추가
extension CanvasViewController {
    
    // MARK: - 상태창에 선택된 스퀘어 뷰를 알리기
    private func informSelectedViewToStatus(color: Color, alpha: Alpha, type blueprint: BlueprintOfViewShape) {
        statusView.isHidden = false
        let buttonTitleString = blueprint == .photo ? "비어있음" : color.hexaColor
        colorButton.setTitle(buttonTitleString, for: .normal)
        adjustSliderAndStepper(color: color, alpha: alpha)
    }
    
    // MARK: - 새로운 스퀘어뷰를 추가하는 메서드
    private func addSquareView(rect: Rectangle, index: Int) {
        let squareView = SquareView(rectangle: rect, index: index)
        createPanGestureRecognizer(targetView: squareView)

        view.addSubview(squareView)
        view.bringSubviewToFront(drawableStackview)
    }
    
    // MARK: - 새로운 사진뷰를 추가하는 메서드
    private func addPhotoView(photo: Photo, index: Int) {
        let photoView = PhotoView(photo: photo, index: index)
        photoView.isUserInteractionEnabled = true
        photoView.image = UIImage(data: photo.image)
        createPanGestureRecognizer(targetView: photoView)
        
        view.addSubview(photoView)
        view.bringSubviewToFront(drawableStackview)
    }
    
    // MARK: - 스테퍼와 슬라이더의 값을 조정하는 메서드
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
            result.itemProvider.loadObject(ofClass: UIImage.self) { [unowned self] reading, error in
                guard let imageData = reading as? UIImage, error == nil else { return }
                let imagePngData = imageData.pngData()
                self.plane.makeShape(with: .photo, image: imagePngData)
            }
        }
    }
}
