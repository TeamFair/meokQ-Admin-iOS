//
//  ImageType.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/23/25.
//

enum ImageType: String, CaseIterable, Identifiable, Hashable {
    case QUEST_IMAGE
    case BANNER_IMAGE
    case USER_PROFILE_IMAGE
    case MARKET_LOGO
    case RECEIPT
    
    var id: String { rawValue }
}
