//
//  GetMarket.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 1/4/24.
//

import Foundation

// MARK: - GetMarketListRequest
struct GetMarketListRequest: Encodable {
    let page: Int
    let size: String = "10"
    let status: String = "UNDER_REVIEW"
}

// MARK:  GetMarketListResponse
struct GetMarketListResponse: Decodable {
    let size: Int
    let data: [GetMarket]
    let total: Int
    let page: Int
    let status: String
    let message: String
}

extension GetMarketListResponse {
    var toDomain: [Market] {
        return self.data.map { Market(marketId: $0.marketId, logoImageId: $0.logoImageId ?? "", logoImage: nil, name: $0.name, status: $0.status) }
    }
}

// MARK: - GetMarketDetailRequest
struct GetMarketDetailRequest: Encodable {
    let marketId: String
}

// MARK: GetMarketDetailResponse
struct GetMarketDetailResponse: Decodable {
    let data: GetMarketDetail
    let status, message: String
}

extension GetMarketDetailResponse {
    var toDomain: MarketDetail {
        return MarketDetail(marketId: data.marketId, logoImage: data.logoImageId, name: data.name, district: data.district, phone: data.phone, address: data.address, status: data.status, marketTime: data.marketTimes)
    }
}

// MARK: - GetMarket
struct GetMarket: Codable {
    let marketId: String
    let logoImageId: String?
    let name: String
    let district: String
    let address: String
    let status: String
    let questCount: Int
    let marketTime: MarketTime?
    
    init(marketId: String, logoImageId: String, name: String, district: String, address: String, status: String, questCount: Int, marketTime: MarketTime) {
        self.marketId = marketId
        self.logoImageId = logoImageId
        self.name = name
        self.district = district
        self.address = address
        self.status = status
        self.questCount = questCount
        self.marketTime = marketTime
    }
}

struct MarketTime: Codable, Equatable {
    var weekDay: String
    var openTime: String
    var closeTime: String
    var holidayYn: String
}

struct LogoImage: Codable {
    var imageId: String
    var location: String
}

// MARK: - GetMarketDetail
struct GetMarketDetail: Codable {
    let marketId, name, phone, district: String
    let address, status: String
    let ticketCount: Int
    let marketTimes: [MarketTime]
    let logoImageId: String
    
    init(marketId: String, name: String, phone: String, district: String, address: String, status: String, ticketCount: Int, marketTimes: [MarketTime], logoImageId: String) {
        self.marketId = marketId
        self.name = name
        self.phone = phone
        self.district = district
        self.address = address
        self.status = status
        self.ticketCount = ticketCount
        self.marketTimes = marketTimes
        self.logoImageId = logoImageId
    }
}
