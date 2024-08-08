//
//  PostQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Foundation
import Combine

protocol PostQuestUseCaseInterface {
    func postQuest(writer: String, imageId: String, missionTitle: String, quantity: Int, expireDate: String) -> AnyPublisher<PostQuestResponse, NetworkError>
}

final class PostQuestUseCase: PostQuestUseCaseInterface {
    
    let questRepository: QuestRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface) {
        self.questRepository = questRepository
    }
    
    // TODO: 여기서 PostQuestResponse 이 모델을 알아야하나?
    func postQuest(writer: String, imageId: String, missionTitle: String, quantity: Int, expireDate: String) -> AnyPublisher<PostQuestResponse, NetworkError> {
        self.questRepository.postQuest(questRequest: PostQuestRequest(writer: writer, imageId: imageId, missions: [.init(content: missionTitle)], rewards: [.init(quantity: quantity)], expireDate: expireDate))
    }
}
