//
//  MarketAuth.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/4/24.
//

import Foundation

struct MarketAuthRiview {
    let marketId: String
    let marketDetail: MarketDetail
    let marketAuth: MarketAuth
}

// TODO: 확인
struct MarketAuth: Equatable {
    let recordId, marketId: String
    let `operator`: Operator
    let license: License
}
