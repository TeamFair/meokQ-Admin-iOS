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
    
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[Quest], NetworkError> {
        questDataSource.getQuestList(request: request)
            .map { response in
                response.map { $0.toDomain(image: nil) }
            }
            .eraseToAnyPublisher()
    }
    
    func postQuest(request: PostQuestRequest) -> AnyPublisher<Void, NetworkError> {
        questDataSource.postQuest(request: request)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func putQuest(request: PutQuestRequest) -> AnyPublisher<Void, NetworkError> {
        questDataSource.putQuest(request: request)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<Void, NetworkError> {
        questDataSource.deleteQuest(request: request)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
