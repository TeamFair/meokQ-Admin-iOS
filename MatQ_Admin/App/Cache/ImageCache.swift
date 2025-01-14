//
//  ImageCache.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 1/13/25.
//

import UIKit

protocol ImageCache {
    func getImage(forKey key: String) -> UIImage?
    func saveImage(_ image: UIImage, forKey key: String)
    func deleteImage(forKey key: String)
}

class InMemoryImageCache: ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
