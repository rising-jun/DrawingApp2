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
    
    //MARK: - 사진 버튼 누르면 실행 되는 액션
    @IBAction func touchedPictureButton(_ sender: UIButton) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
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
                          let index = noti.userInfo?[NotificationKey.index] as? Int,
                    let image = self.image else { return }
                    addPhotoView(photo: photo, image: image, index: index)
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
    /// 스퀘어 뷰를 넘길 것인지? 아니면 업데이트할 정보만 넘길 것인지?
    /// 이게 어느때 불려야하는가?
    /// 1. selectedView 에 값이 들어갔을 때, - 이때는 뷰의 값만 전달 할 수가 있음. 뷰의 UIColor 를 보고 컬러와 알파값을 구해내는게 가능한가?
    /// 2. 색상이나 알파값이 변경되었을 때 - 색상이나 알파값이 전달, 근데 사각형을 생성할 땐, 어떤 값이 들어가는지..? 아니면 렉탱글을 가지고 있으면 되는데 ...?
    /// 3. 빈공간이 터치되었을 때 - 구현 완
    private func informSelectedViewToStatus(color: Color, alpha: Alpha, type blueprint: BlueprintOfViewShape) {
        statusView.isHidden = false
        let buttonTitleString = blueprint == .photo ? "비어있음" : color.hexaColor
        colorButton.setTitle(buttonTitleString, for: .normal)
        adjustSliderAndStepper(color: color, alpha: alpha)
    }
    
    // MARK: - 새로운 스퀘어뷰를 추가하는 메서드
    private func addSquareView(rect: Rectangle, index: Int) {
        let squareView = SquareView(rectangle: rect, index: index)
        view.addSubview(squareView)
        view.bringSubviewToFront(drawableStackview)
    }
    
    // MARK: - 새로운 사진뷰를 추가하는 메서드
    private func addPhotoView(photo: Photo, image: UIImage, index: Int) {
        let photoView = PhotoView(photo: photo, index: index)
        photoView.image = image
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
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                self.image = image
                self.plane.makeShape(with: .photo)
            }
        }
    }
}
