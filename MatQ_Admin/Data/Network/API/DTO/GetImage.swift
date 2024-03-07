//
//  GetImage.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/8/24.
//

import Foundation
import UIKit

// MARK: - GetImageRequest
struct GetImageRequest: Encodable {
    let imageId: String
}

// MARK: - DeleteImageRequest
struct DeleteImageRequest: Encodable {
    let imageId: String
}

// MARK:  DeleteImageResponse
struct DeleteImageResponse: Decodable {
    let data: [String: String]?
    let errMessage: String?
    let status: String?
    let message: String?
}
