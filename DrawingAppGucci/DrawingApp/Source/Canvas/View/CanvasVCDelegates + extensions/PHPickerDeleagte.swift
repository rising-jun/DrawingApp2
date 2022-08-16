//
//  PHPickerDeleagte.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/08/16.
//

import UIKit
import Photos
import PhotosUI

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
