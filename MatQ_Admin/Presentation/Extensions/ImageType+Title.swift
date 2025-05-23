//
//  ImageType+Title.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/23/25.
//

extension ImageType: StringValue {
    var title: String {
        switch self {
        case .QUEST_IMAGE:
            "퀘스트"
        case .BANNER_IMAGE:
            "배너"
        case .USER_PROFILE_IMAGE:
            "프로필"
        case .MARKET_LOGO:
            "마켓 로고"
        case .RECEIPT:
            "영수증"
        }
    }
}
