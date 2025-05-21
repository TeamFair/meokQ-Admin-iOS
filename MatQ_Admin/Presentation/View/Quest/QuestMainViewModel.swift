//
//  QuestMainViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import Foundation
import Combine
import SwiftUI


protocol QuestMainViewModelInput {
    func getQuestList(page: Int) async
}

protocol QuestMainViewModelOutput {
    var items: [QuestMainViewModelItem] { get }
    var error: PassthroughSubject<String, Never> { get }
}

final class QuestMainViewModel: QuestMainViewModelInput, QuestMainViewModelOutput, ObservableObject {
    private let questUseCase: GetQuestUseCaseInterface
    
    var questList: [Quest] = [Quest.mockData1, Quest.mockData2]
    private var currentPage: Int = 0
    
    @Published var items: [QuestMainViewModelItem] = []
    var filteredItems: [QuestMainViewModelItem] {
        let selectedTypes = selectedType.filter { $0.value == true }.map { $0.key }
        let selectedMissionTypes = selectedMissionType.filter { $0.value == true }.map { $0.key }

        let filteredItems = items
            .filter { selectedTypes.contains($0.type) } // 선택된 타입 필터링
            .filter { selectedMissionTypes.contains($0.missionType) } // 선택된 미션 타입 필터링
            .filter { showPopularOnly ? $0.popularYn : true } // 인기 여부 필터링
            .filter { item in
                // 검색어 필터링
                let imageIds = [item.mainImageId, item.writerImageId].filter({ $0 != "" })
                return item.missionTitle
                    .contains(searchText) ||
                item.writer
                    .contains(searchText) ||
                imageIds
                    .compactMap { $0?.contains(searchText) }
                    .contains(true) || searchText.isEmpty
            }
        
        return filteredItems
    }
    
    @Published var selectedType: [QuestType: Bool] = [.normal: true, .repeat: true, .event: true]
    @Published var selectedMissionType: [MissionType: Bool] = [.WORDS: true, .OX: true, .FREE: true]
    @Published var showPopularOnly = false

    @Published var searchText: String = ""
    @Published var errorMessage: String = ""
    @Published var showingAlert = false
    @Published var showingErrorAlert = false
    @Published var viewState: ViewState = .loaded
    
    @Published var showSearchBar: Bool = true
    @Published var scrollOffset: CGFloat = 0.0
    let scrollThreshold: CGFloat = 20.0 // 임계값 설정
    
    @AppStorage("port") var port = "8880"
    @Published var portText = ""
    
    enum ViewState {
        case empty
        case loading
        case loaded
    }
    
    var error = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    
    init(questUseCase: GetQuestUseCaseInterface) {
        self.questUseCase = questUseCase
        
        error.sink { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.showingErrorAlert = true
        }.store(in: &cancellables)
        
        AuthRepository(networkService: NetworkService()).postAuth(request: PostAuthRequest())
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Authorization token saved successfully.")
                case .failure(let error):
                    print("Failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                print("Authorization token receiveValue")
            })
            .store(in: &cancellables)
        
        getQuestList(page: 0)
    }

    func getQuestList(page: Int) {
        viewState = .loading
        questUseCase.execute(page: page)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.viewState = self.items.isEmpty ? .empty : .loaded
                case .failure:
                    self.error.send("Fail to load Quest")
                    self.viewState = .empty
                }
            } receiveValue: { [weak self] result in
                if page == 0 {
                    self?.items = []
                    self?.questList = []
                }
                
                for item in result.map(QuestMainViewModelItem.init) {
                    self?.items.append(item)
                }
                // TODO: 페이지네이션
                self?.questList += result
                self?.viewState = .loaded
            }
            .store(in: &cancellables)
    }
    
    func getSelectedQuest(_ item: QuestMainViewModelItem) -> Quest? {
        guard let selectedQuest = questList.first(where: { $0.questId == item.questId }) else {
            print("Quest not found for questId: \(item.questId)")
            return nil
        }
        let quest = Quest(
            questId: selectedQuest.questId,
            mission: selectedQuest.mission,
            rewardList: selectedQuest.rewardList,
            status: selectedQuest.status,
            writer: selectedQuest.writer,
            writerImage: selectedQuest.writerImage,
            writerImageId: selectedQuest.writerImageId ?? "",
            mainImage: selectedQuest.mainImage,
            mainImageId: selectedQuest.mainImageId ?? "",
            expireDate: selectedQuest.expireDate,
            score: selectedQuest.score,
            type: selectedQuest.type,
            target: selectedQuest.target,
            popularYn: selectedQuest.popularYn
        )
        
        return quest
    }
    
    func clearSearchText() {
        self.searchText = ""
    }
    
    func updateSearchBarVisibility(offset: CGFloat) {
        if viewState == .loaded {
            withAnimation {
                if offset >= 0 {
                    showSearchBar = true // 최상단에서 SearchBar 표시
                } else if offset < scrollOffset - scrollThreshold {
                    showSearchBar = false // 아래로 스크롤 시 숨김
                } else if offset > scrollOffset + scrollThreshold {
                    showSearchBar = true // 위로 스크롤 시 표시
                }
                scrollOffset = offset
            }
        }
    }
}

struct QuestMainViewModelItem: Hashable {
    let questId: String
    let mission: Mission
    let writerImageId: String?
    let writerImage: UIImage? 
    let mainImageId: String?
    let mainImage: UIImage?
    let status: String
    let expireDate: String
    let writer: String
    let popularYn: Bool
    let type: QuestType
    let target: QuestRepeatTarget
    let xpStats: [XpStat]
    
    var missionTitle: String {
        return mission.content
    }
    var missionType: MissionType {
        return MissionType(rawValue: mission.type) ?? .FREE

    }
    
    init(questId: String, mission: Mission, writerImageId: String, writerImage: UIImage?, mainImageId: String, mainImage: UIImage?, status: String, expireDate: String, writer: String, type: QuestType, target: QuestRepeatTarget, popularYn: Bool, xpStats: [XpStat]) {
        self.questId = questId
        self.mission = mission
        self.writerImageId = writerImageId
        self.writerImage = writerImage
        self.mainImageId = mainImageId
        self.mainImage = mainImage
        self.status = status
        self.expireDate = expireDate
        self.writer = writer
        self.popularYn = popularYn
        self.type = type
        self.target = target
        self.xpStats = xpStats
    }
    
    init(quest: Quest) {
        self.questId = quest.questId
        self.mission = quest.mission
        self.writerImageId = quest.writerImageId
        self.writerImage = quest.writerImage
        self.mainImageId = quest.mainImageId
        self.mainImage = quest.mainImage
        self.status = quest.status
        self.expireDate = quest.expireDate.timeAgoSinceDate()
        self.writer = quest.writer
        self.popularYn = quest.popularYn
        self.type = QuestType(rawValue: quest.type.lowercased()) ?? .normal
        self.target = QuestRepeatTarget(rawValue: quest.target.lowercased()) ?? .none
        self.xpStats = quest.rewardList.map { XpStat(rawValue: $0.content?.lowercased() ?? "fun") ?? .fun }
    }
    
    static var mockData1 = QuestMainViewModelItem.init(quest: .mockData1)
    static var mockData2 = QuestMainViewModelItem.init(quest: .mockData2)
}
