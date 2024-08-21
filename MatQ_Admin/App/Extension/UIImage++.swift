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
    
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

enum UIImageSize {
    case small
    case medium
    case maxWidth
    case custom(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .small:
            return 76
        case .medium:
            return 160
        case .maxWidth:
            return UIScreen.main.bounds.width - 40
        case .custom(let size):
            return size
        }
    }
}
