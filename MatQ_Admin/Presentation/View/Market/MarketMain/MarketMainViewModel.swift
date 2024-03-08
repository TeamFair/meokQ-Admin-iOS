//
//  MarketMainViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import Combine
import UIKit

protocol MarketMainViewModelInput {
    func getMarketList(page: Int) async
}

protocol MarketMainViewModelOutput {
    var items: [MarketItemViewModel] { get }
    var error: PassthroughSubject<String, Never> { get }
}

final class MarketMainViewModel: MarketMainViewModelInput, MarketMainViewModelOutput, ObservableObject {
    
    private let marketUseCase: GetMarketUseCaseInterface
    
    private var marketList: [Market] = []
    private var currentPage: Int = 0

    @Published var items: [MarketItemViewModel] = []
    @Published var errorMessage: String = ""
    @Published var showingAlert = false
    
    var error = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(marketUseCase: GetMarketUseCaseInterface) {
        self.marketUseCase = marketUseCase
        
        error.sink { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.showingAlert.toggle()
        }.store(in: &cancellables)
    }

    @MainActor
    func getMarketList(page: Int) async {
        await marketUseCase.getMarketList(page: page)
            .sink { completion in
                switch completion {
                case .finished:
                    print("well finished")
                case .failure(let error):
                    print(error)
                    self.error.send("Fail to load Markets")
                }
            } receiveValue: { [weak self] result in
                for item in result.map(MarketItemViewModel.init) {
                    self?.items.append(item)
                }
                // TODO: 페이지네이션, refresh에는 초기화
                self?.marketList += result
            }
            .store(in: &cancellables)
    }
}

struct MarketItemViewModel: Equatable {
    let marketId: String
    let logoImageId: String
    let logoImage: UIImage?
    let name: String
    
    init(market: Market) {
        self.marketId = market.marketId
        self.logoImageId = market.logoImageId
        self.logoImage = market.logoImage
        self.name = market.name
    }
}
