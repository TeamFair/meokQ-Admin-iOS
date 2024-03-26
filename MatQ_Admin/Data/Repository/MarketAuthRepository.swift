//
//  MarketAuthRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/4/24.
//

import Combine
import UIKit

final class MarketAuthRepository: MarketAuthRepositoryInterface {
    
    let marketAuthService: MarketAuthServiceInterface
    let imageService: ImageServiceInterface

    init(marketAuthService: MarketAuthServiceInterface, imageService: ImageServiceInterface) {
        self.marketAuthService = marketAuthService
        self.imageService = imageService
    }
    
    func getMarketAuth(marketId: String) async throws -> [MarketAuth] {
        let request = GetMarketAuthRequest(marketId: marketId)
        let result = await self.marketAuthService.getMarketAuth(request: request)
        
        switch result {
        case .success(var markets):
            if let imageId = markets.first?.license.licenseImage.imageId {
                markets[0].license.image = await loadImage(imageId: imageId)
                markets[0].operator.idcardUIImage = await loadImage(imageId: imageId)
            }
            return markets
        case .failure:
            throw NetworkError.serverError
        }
    }
    
    func putMarketAuthReview(recordId: String, comment: String?, reviewResult: ReviewResult) async -> AnyPublisher<Bool, NetworkError> {
        let request = PutReviewMarketAuthRequest(recordId: recordId, comment: comment, reviewResult: reviewResult.statusText)
        let result = await self.marketAuthService.putMarketReview(request: request)
        
        return Future<Bool, NetworkError> { promise in
            switch result {
            case .success(let bool):
                promise(.success(bool))
            case .failure:
                promise(.failure(NetworkError.serverError))
            }
        }.eraseToAnyPublisher()
    }
        
    private func loadImage(imageId: String) async -> UIImage? {
        guard imageId != "" else  { return nil }
        
        let imageResponse = await self.imageService.getImage(request: .init(imageId: imageId))
        
        switch imageResponse {
        case .success(let uiImage):
            return uiImage
        case .failure:
            return nil
        }
    }
}
