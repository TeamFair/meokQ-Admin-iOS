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
    
    // Alert 관련
    @Published var showAlert = false
    @Published var alertItem: AlertItem?
    let alertPublisher = PassthroughSubject<AlertItem, Never>()

    @Published var viewState: ViewState = .loaded
    
    @Published var showPortSheet = false
    
    enum ViewState {
        case empty
        case loading
        case loaded
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(bannerUseCase: GetBannersUseCaseInterface) {
        self.bannerUseCase = bannerUseCase
        bind()
        getBanners()
    }
    
    private func bind() {
        alertPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] alert in
                self?.alertItem = alert
                self?.showAlert = true
            }
            .store(in: &cancellables)
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
                    self.alertPublisher.send(AlertStateFactory.simple(title: "배너 조회 실패", message: error.message))
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
    
    func showPortChangeSheet() {
        showPortSheet = true
    }
    
    func onPortChanged() {
        getBanners()
    }
}
