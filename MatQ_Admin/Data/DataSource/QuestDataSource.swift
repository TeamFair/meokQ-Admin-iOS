//
//  QuestDataSource.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Alamofire
import Combine
import Foundation

protocol QuestDataSourceInterface {
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[GetQuestResponseData], NetworkError>
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
    func putQuest(request: PutQuestRequest) -> AnyPublisher<PutQuestResponse, NetworkError>
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
}

struct QuestDataSource: QuestDataSourceInterface {
    private let networkService: NetworkServiceInterface
    
    init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }
    
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[GetQuestResponseData], NetworkError> {
        networkService.request(QuestTarget.getQuest(request), as: ResponseWithPage<[GetQuestResponseData]>.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError> {
        networkService.request(QuestTarget.postQuest(request), as: PostQuestResponse.self)
    }

    func putQuest(request: PutQuestRequest) -> AnyPublisher<PutQuestResponse, NetworkError> {
        networkService.request(QuestTarget.putQuest(request), as: PutQuestResponse.self)
    }
    
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<DeleteQuestResponse, NetworkError> {
        networkService.request(QuestTarget.deleteQuest(request), as: DeleteQuestResponse.self)
    }
}
