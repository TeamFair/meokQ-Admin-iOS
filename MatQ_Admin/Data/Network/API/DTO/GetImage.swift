//
//  GetImage.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/8/24.
//

import Foundation
import UIKit

// MARK: - 이미지 조회
struct GetImageRequest: Encodable {
    let imageId: String
}

// MARK: - 이미지 등록
struct PostImageRequest: Encodable {
    let type: String
    let data: Data
}

typealias PostImageResponse =  Response<PostImageResponseData>
struct PostImageResponseData: Decodable {
    let imageId: String
}

// MARK: - 이미지 삭제
struct DeleteImageRequest: Encodable {
    let imageId: String
}

typealias DeleteImageResponse = ResponseWithoutData
