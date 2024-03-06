//
//  MarketService.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 1/4/24.
//

import Alamofire
import Combine
import Foundation

protocol MarketServiceInterface {
    func fetchMarketList(request: GetMarketListRequest) async -> Result<[Market], NetworkError>
    func fetchMarketDetail(request: GetMarketDetailRequest) async -> Result<MarketDetail, NetworkError>
}

struct MarketService: MarketServiceInterface {
    func fetchMarketList(request: GetMarketListRequest) async -> Result<[Market], NetworkError> {
        let taskRequest = AF.request(MarketTarget.getMarketList(request))
            .serializingDecodable(GetMarketListResponse.self)
        
        switch await taskRequest.result {
        case .success(let response):
            return .success(response.toDomain)
        case .failure:
            return .failure(NetworkError.serverError)
        }
    }
    
    func fetchMarketDetail(request: GetMarketDetailRequest) async -> Result<MarketDetail, NetworkError> {
        let request = AF.request(MarketTarget.getMarketDetail(request))
            .serializingDecodable(GetMarketDetailResponse.self)
        
        switch await request.result {
        case .success(let response):
            dump(response)
            return .success(response.toDomain)
        case .failure:
            return .failure(NetworkError.serverError)
        }
    }
}
