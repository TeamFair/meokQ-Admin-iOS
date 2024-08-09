//
//  ImageDataTransferable.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/9/24.
//

import SwiftUI
struct ImageDataTransferable: Transferable {
    let imageData: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            return ImageDataTransferable(imageData: data)
        }
    }
    
    var uiImage: UIImage? {
        return UIImage(data: imageData)
    }
}
