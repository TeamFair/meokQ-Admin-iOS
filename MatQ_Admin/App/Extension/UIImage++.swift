//
//  UIImage++.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/9/24.
//

import UIKit

extension UIImage {
    func downSample(scale: CGFloat) -> UIImage? {
        let maxPixel = max(self.size.width, self.size.height) * scale
        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: maxPixel,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: false
        ]

        guard let data = self.pngData() as CFData?,
              let imageSource = CGImageSourceCreateWithData(data, nil),
              let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else {
            return nil
        }

        return UIImage(cgImage: scaledImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
      
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

enum UIImageSize {
    case small
    case regular
    case medium
    case large
    case maxWidth
    case custom(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .small:
            return 48
        case .regular:
            return 88
        case .medium:
            return 160
        case .large:
            return 260
        case .maxWidth:
            return UIScreen.main.bounds.width
        case .custom(let size):
            return size
        }
    }
}
