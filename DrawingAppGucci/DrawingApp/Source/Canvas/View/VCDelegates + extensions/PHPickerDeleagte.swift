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
        results.forEach { result in
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] (url, error) in
                guard let url = url else { return }
                do {
                    url.asSmallImageData
                    self?.plane.makeShape(with: .photo, by: url.asSmallImageData)
                }
                catch {
                    fatalError("\(#file), \(#function) occured an error")
                }
                
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
