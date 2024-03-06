//
//  Market.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import Foundation

/// 메인 뷰 사용
struct Market {
    let marketId: String
    let logoImageId: String
    let name: String
    let status: String
}

/// 인증 들어갈 때 사용
struct MarketDetail: Equatable {
    let marketId: String
    let logoImage: String
    let name: String
    let district: String
    let phone: String
    let address: String
    let status: String
    let marketTime: [MarketTime]?
}
