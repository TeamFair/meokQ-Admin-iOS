//
//  PutQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 9/24/24.
//

import Combine
import UIKit

struct PutQuestRequestModel {
    let questId: String
    let writer: String
    var writerImageId: String?
    let missions: [Mission]
    let rewards: [Reward]
    let score: Int
    let expireDate: String
    var target: String
    let type: String
    var mainImageId: String?
    let popularYn: Bool
    
    func toPutQuestRequest() -> PutQuestRequest? {
        guard let imageId = writerImageId else { return nil } // TODO: 이미지 없으면 ""로 등록하도록 수정
        return PutQuestRequest(
            questId: self.questId,
            quest: .init(
                writer: self.writer,
                imageId: imageId,
                missions: self.missions,
                rewards: self.rewards,
                score: self.score,
                expireDate: self.expireDate,
                type: self.type,
                target: self.target,
                mainImageId: self.mainImageId,
                popularYn: self.popularYn
            )
        )
    }
}

protocol PutQuestUseCaseInterface {
    func execute(
        request: PutQuestRequestModel
    ) -> AnyPublisher<Void, NetworkError>
}

final class PutQuestUseCase: PutQuestUseCaseInterface {
    let questRepository: QuestRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface) {
        self.questRepository = questRepository
    }
    
    func execute(request: PutQuestRequestModel) -> AnyPublisher<Void,NetworkError> {
        guard let validRequest = request.toPutQuestRequest() else {
            return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
        }
        
        return questRepository.putQuest(request: validRequest).eraseToAnyPublisher()
    }
}
