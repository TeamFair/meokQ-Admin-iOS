//
//  MarketAuthReviewViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/4/24.
//

import Combine
import Foundation

protocol MarketAuthReviewViewModelInput {
    func getMarketInfo() async
    func putMarketReviewAuth() async
}

protocol MarketAuthReviewViewModelOutput {
    var items: MarketAuthReviewItemViewModel { get }
    var error: PassthroughSubject<String, Never> { get }
}

final class MarketAuthReviewViewModel: MarketAuthReviewViewModelInput, MarketAuthReviewViewModelOutput, ObservableObject {

    private let fetchMarketMaterialsUseCase: FetchMarketReviewMaterialsUseCaseInterface
    let marketId: String

    // MARK: Output
    var items: MarketAuthReviewItemViewModel = MarketAuthReviewItemViewModel(marketId: "", name: "", marketAuth: .init(recordId: "", marketId: "", operator: .init(name: "", birthdate: "", idcardImage: .init(imageId: "", location: "")), license: .init(licenseId: "", licenseImage: .init(imageId: "", location: ""), ownerName: "", marketName: "", address: "", postalCode: "")), marketDetail: .init(marketId: "", logoImage: "", name: "", district: "", phone: "", address: "", status: "", marketTime: []))

    var error = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(marketAuthUseCase: FetchMarketReviewMaterialsUseCaseInterface, marketId: String) {
        self.fetchMarketMaterialsUseCase = marketAuthUseCase
        self.marketId = marketId
    }
    
    func getMarketInfo() async {
        do {
            let (detailResult, authResults) = try await fetchMarketMaterialsUseCase.execute(marketId: marketId)
            // TODO: 첫번째만 확인하면 되는 게 맞는지 확인
            guard let authResult = authResults.first else  {
                self.error.send("Fail to load Markets Auth")
                return
            }
            
            let authItemViewModel = MarketAuthReviewItemViewModel(marketId: marketId, name: detailResult.name, marketAuth: authResult, marketDetail: detailResult)
            
            self.items = authItemViewModel
        } catch {
            self.error.send("Fail to load market")
        }
    }
    
    func putMarketReviewAuth() async {

    }
}

struct MarketAuthReviewItemViewModel: Equatable {
    let marketId: String
    let name: String
    let marketAuth: MarketAuth // TODO: 옵셔널
    let marketDetail: MarketDetail
  
    init(marketId: String, name: String, marketAuth: MarketAuth, marketDetail: MarketDetail) {
        self.marketId = marketId
        self.name = name
        self.marketAuth = marketAuth
        self.marketDetail = marketDetail
    }
}
