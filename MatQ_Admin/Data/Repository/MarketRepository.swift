//
//  MarketRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import Combine
import UIKit

final class MarketRepository: MarketRepositoryInterface {
    
    let marketService: MarketServiceInterface
    let imageService: ImageServiceInterface
    
    init(marketService: MarketServiceInterface, imageService: ImageServiceInterface) {
        self.marketService = marketService
        self.imageService = imageService
    }
    
    func getMarketList(page: Int) async -> AnyPublisher<[Market], NetworkError> {
        let request = GetMarketListRequest(page: page)
        
        do {
            let marketListResponse = await self.marketService.fetchMarketList(request: request)
            let mappedData = try await mapImagesAsync(marketListResponse)//.get()
            return Result.Publisher(.success(mappedData))
                .eraseToAnyPublisher()
        } catch {
            return Result.Publisher(.failure(NetworkError.unknownError))
                .eraseToAnyPublisher()
        }
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
    
    private func mapImagesAsync(_ marketListResponse: Result<[Market], NetworkError>) async throws -> [Market] {
        switch marketListResponse {
        case .success(var res):
            try await withThrowingTaskGroup(of: (index: Int, market: Market).self) { group in
                for index in res.indices {
                    let market = res[index]
                    group.addTask {
                        let uiImage = await self.updateMarketImage(market)
                        var modifiedMarket = market
                        modifiedMarket.logoImage = uiImage
                        return (index, modifiedMarket)
                    }
                }
                for try await (index, modifiedMarket) in group {
                    res[index] = modifiedMarket
                }
            }
            return res
        case .failure(let error):
            throw error
        }
    }
    
    private func updateMarketImage(_ market: Market) async -> UIImage? {
        var updatedMarket = market
        updatedMarket.logoImage = await self.loadImage(imageId: market.logoImageId)
        return updatedMarket.logoImage
    }
    
    func getMarketDetail(marketId: String) async throws -> MarketDetail {
        let result = await self.marketService.fetchMarketDetail(request: GetMarketDetailRequest(marketId: marketId))
        switch result {
        case .success(var data):
            data.logoImage = await loadImage(imageId: data.logoImageId)
            return data
        case .failure:
            throw NetworkError.serverError
        }
    }
}
