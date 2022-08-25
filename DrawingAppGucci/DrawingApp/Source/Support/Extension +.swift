//
//  Extension +.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/08.
//

import os.log
import UIKit
import UniformTypeIdentifiers

extension OSLog {
    static var subsystem = Bundle.main.bundleIdentifier!
    
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let model = OSLog(subsystem: subsystem, category: "Model")
}

//MARK: - 이 사이즈를 컴파일 하기 전에 알 수 있나?
enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width - 120.0
    static let height = UIScreen.main.bounds.size.height - 150.0
}

extension UIView {
    func drawEdges(selected: Bool) {
        self.layer.borderWidth = selected ? 3 : 0
    }
}

enum ShapeSize {
    static let width: Double = 150.0
    static let height: Double = 120.0
}

extension CGImage {
    
    var isPNG: Bool {
        if #available(iOS 14.0, *) {
            return (utType as String?) == UTType.png.identifier
        } else {
            return utType == UTType.png.identifier as CFString
        }
    }
}

extension URL {
    var asSmallImageData: Data? {
        
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        // URL -> CgImageSource
        guard let source = CGImageSourceCreateWithURL(self as CFURL, sourceOptions) else { return nil }
        
        // Screen size
        let scale: CGFloat = UIScreen.main.scale
        
        // Pixel scale fitted to PhotoView
        let maxDimensionsInPixel = max(ShapeSize.height, ShapeSize.width) * scale
        
        // Downsampling options
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionsInPixel,
            kCGImageSourceShouldCacheImmediately: true
        ] as CFDictionary
        
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else { return nil }
        
        // Convert cgImage to Data
        let data = NSMutableData()
        guard let imageDestination = CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil) else { return nil }
        
        let destinationProperties = [kCGImageDestinationLossyCompressionQuality: cgImage.isPNG ? 1.0 : 0.75] as CFDictionary
        CGImageDestinationAddImage(imageDestination, cgImage, destinationProperties)
        CGImageDestinationFinalize(imageDestination)
        
        return data as Data
    }
}
