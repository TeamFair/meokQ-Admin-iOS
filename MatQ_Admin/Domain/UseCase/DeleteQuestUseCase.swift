//
//  DeleteQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Foundation
import Combine

protocol DeleteQuestUseCaseInterface {
    func execute(questId: String, type: QuestDeleteType) -> AnyPublisher<Void, NetworkError>
}

final class DeleteQuestUseCase: DeleteQuestUseCaseInterface {
    
    let questRepository: QuestRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface) {
        self.questRepository = questRepository
    }
    
    func execute(questId: String, type: QuestDeleteType) -> AnyPublisher<Void, NetworkError> {
        self.questRepository.deleteQuest(request: DeleteQuestRequest(questId: DeleteQuestRequest.QuestId(questId: questId), deleteType: type))
    }
}
