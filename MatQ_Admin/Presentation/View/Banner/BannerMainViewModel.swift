//
//  BannerMainViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import Combine
import SwiftUI

final class BannerMainViewModel: ObservableObject {
    private let bannerUseCase: GetBannersUseCaseInterface
    
    @Published var banners: [Banner] = []
    
    @Published var errorMessage: String = ""
    @Published var showingAlert = false
    @Published var showingErrorAlert = false
    @Published var viewState: ViewState = .loaded
    
    @AppStorage("port") var port = "8880"
    @Published var portText = ""
    
    enum ViewState {
        case empty
        case loading
        case loaded
    }
    
    var error = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(bannerUseCase: GetBannersUseCaseInterface) {
        self.bannerUseCase = bannerUseCase
        
        error.sink { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.showingErrorAlert = true
        }.store(in: &cancellables)
        
        getBanners()
    }
    
    func getBanners() {
        viewState = .loading
        
        bannerUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.viewState = self.banners.isEmpty ? .empty : .loaded
                case .failure(let error):
                    self.error.send("배너 조회 실패\(error.message)")
                    self.viewState = .empty
                }
            } receiveValue: { [weak self] banners in
                self?.banners = banners
            }
            .store(in: &cancellables)
    }
    
    func getSelectedBanner(_ item: Banner) -> Banner? {
        guard let selectedBanner = banners.first(where: { $0.id == item.id }) else {
            print("배너 \(item.id)를 찾을 수 없습니다.")
            return nil
        }
        
        return selectedBanner
    }
}
