//
//  ImageModel.swift
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

// MARK: - 이미지 목록 조회
/// BUSINESS_REGISTRATION_CERTIFICATE, ID_CARD, MARKET_LOGO, RECEIPT, QUEST_IMAGE, BANNER_IMAGE, USER_PROFILE_IMAGE
struct GetImageIdsRequest: Encodable {
    let type: String
}

typealias GetImageIdsResponse = Response<[GetImageIdsResponseData]>
struct GetImageIdsResponseData: Decodable {
    let imageId: String
}
    
// MARK: - 이미지 등록
struct PostImageRequest: Encodable {
    let type: ImageRequestType
    let data: Data
    
    init(type: String, data: Data) {
        self.type = ImageRequestType(type: type)
        self.data = data
    }
    
    struct ImageRequestType: Encodable {
        let type: String
    }
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
