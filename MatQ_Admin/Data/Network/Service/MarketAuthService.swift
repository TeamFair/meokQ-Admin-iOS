//
//  MarketAuthService.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/4/24.
//

import Alamofire

protocol MarketAuthServiceInterface {
    func getMarketAuth(request: GetMarketAuthRequest) async -> Result<[MarketAuth], NetworkError>
    func putMarketReview(request: PutReviewMarketAuthRequest) async -> Result<Bool, NetworkError>
}

struct MarketAuthService: MarketAuthServiceInterface {
   func getMarketAuth(request: GetMarketAuthRequest) async -> Result<[MarketAuth], NetworkError> {
        let taskRequest = AF.request(MarketAuthTarget.getMarketAuth(request))
           .validate(statusCode: 200..<300)
            .serializingDecodable(GetMarketAuthResponse.self)
       switch await taskRequest.result {
        case .success(let response):
            return .success(response.toDomain)
        case .failure(let err):
            return .failure(NetworkError.serverError)
        }
    }
    
    func putMarketReview(request: PutReviewMarketAuthRequest) async -> Result<Bool, NetworkError> {
        let request = AF.request(MarketAuthTarget.putMarketAuthReview(request))
            .validate(statusCode: 200..<300)
            .serializingDecodable(PutReviewMarketAuthResponse.self)
        // TODO: 예외처리
        switch await request.result {
        case .success:
            return .success(true)
        case .failure:
            return .failure(NetworkError.serverError)
        }
    }
}
