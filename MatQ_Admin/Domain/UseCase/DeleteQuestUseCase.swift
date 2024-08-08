//
//  DeleteQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Foundation
import Combine

protocol DeleteQuestUseCaseInterface {
    func deleteQuest(questId: String, type: QuestDeleteType) -> AnyPublisher<DeleteQuestResponse, NetworkError>
}

final class DeleteQuestUseCase: DeleteQuestUseCaseInterface {
    
    let questRepository: QuestRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface) {
        self.questRepository = questRepository
    }
    
    func deleteQuest(questId: String, type: QuestDeleteType) -> AnyPublisher<DeleteQuestResponse, NetworkError> {
        self.questRepository.deleteQuest(questRequest: DeleteQuestRequest(questId: DeleteQuestRequest.QuestId(questId: questId), deleteType: type))
    }
}
