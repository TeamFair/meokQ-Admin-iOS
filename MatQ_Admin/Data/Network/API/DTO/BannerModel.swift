//
//  BannerModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import Foundation
import UIKit

// MARK: - 배너 목록 조회
struct GetBannersRequest: Encodable {
    let titleLike: String = ""
    let descriptionLike: String = ""
    // let activeYn: String = "Y"
    let page: Int = 0
    let size: Int = 10
}

typealias GetBannersResponse = ResponseWithPage<[GetBannersResponseData]>

struct GetBannersResponseData: Decodable {
    let id: Int
    let title: String
    let description: String
    let image: ImageResponse
    let activeYn: String
    
    struct ImageResponse: Decodable {
        let imageId: String
    }
    
    func toDomain(image: UIImage?) -> Banner {
        return Banner(
            id: self.id,
            imageId: self.image.imageId,
            image: image,
            title: self.title,
            description: self.description,
            activeYn: self.activeYn
        )
    }
}


// MARK: - 배너 정보 등록
struct PostBannerRequest: Encodable {
    let title: String
    let description: String
    let imageId: String
}

typealias PostBannerResponse = Response<PostBannerResponseData>

struct PostBannerResponseData: Decodable {
    let bannerId: Int
}

// MARK: - 배너 정보 수정
struct PutBannerRequest: Encodable {
    let bannerId: Int
    let banner: BannerRequest
    
    struct BannerRequest: Encodable {
        let title: String
        let description: String
        let activeYn: String
    }
}

typealias PutBannerResponse = ResponseWithoutData


// MARK: - 배너 삭제
struct DeleteBannerRequest: Encodable {
    let bannerId: Int
}

typealias DeleteBannerResponse = ResponseWithoutData
