//
//  QuestRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine
import UIKit

final class QuestRepository: QuestRepositoryInterface {
    let questDataSource: QuestDataSourceInterface
    
    init(questDataSource: QuestDataSourceInterface) {
        self.questDataSource = questDataSource
    }
    
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[GetQuestResponseData], NetworkError> {
        questDataSource.getQuestList(request: request)
    }
    
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError> {
        questDataSource.postQuest(request: request)
    }
    
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<DeleteQuestResponse, NetworkError> {
        questDataSource.deleteQuest(request: request)
    }
}
