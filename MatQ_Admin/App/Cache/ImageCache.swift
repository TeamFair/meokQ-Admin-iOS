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
    func fetchAllImages() -> [(String, UIImage)]
}

class InMemoryImageCache: ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var keys: [String] = []  // 저장된 이미지 키 목록

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        if !keys.contains(key) {
            keys.append(key)
        }
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        keys.removeAll { $0 == key }
    }
    
    func fetchAllImages() -> [(String, UIImage)] {
        return keys.compactMap { key in
            if let image = cache.object(forKey: key as NSString) {
                return (key, image)
            }
            return nil
        }
    }
}
