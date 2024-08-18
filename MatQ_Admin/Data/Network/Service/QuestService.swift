//
//  QuestService.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Alamofire
import Combine
import Foundation

protocol QuestServiceInterface {
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[GetQuestResponseData], NetworkError>
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
}

struct QuestService: QuestServiceInterface {
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[GetQuestResponseData], NetworkError> {
        NetworkUtils.request(QuestTarget.getQuest(request), as: ResponseWithPage<[GetQuestResponseData]>.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError> {
        NetworkUtils.request(QuestTarget.postQuest(request), as: PostQuestResponse.self)
    }

    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<DeleteQuestResponse, NetworkError> {
        NetworkUtils.request(QuestTarget.deleteQuest(request), as: DeleteQuestResponse.self)
    }
}
