//
//  MarketRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Combine

protocol MarketRepositoryInterface {
    func getMarketList(page: Int) async -> AnyPublisher<[Market], NetworkError>
    func getMarketDetail(marketId: String) async throws -> MarketDetail
}
