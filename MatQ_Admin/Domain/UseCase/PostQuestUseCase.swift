//
//  PostQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine
import UIKit

protocol PostQuestUseCaseInterface {
    func execute(
        request: PostQuestRequestModel
    ) -> AnyPublisher<Void, NetworkError>
}

/// 퀘스트 생성 유스케이스
final class PostQuestUseCase: PostQuestUseCaseInterface {
    
    let questRepository: QuestRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.questRepository = questRepository
        self.imageRepository = imageRepository
    }
    
    func execute(
        request: PostQuestRequestModel
    ) -> AnyPublisher<Void, NetworkError> {
        let request = request.toPostQuestRequest()
        return questRepository.postQuest(request: request).eraseToAnyPublisher()
    }
}

/// 뷰모델&유스케이스 통신
struct PostQuestRequestModel {
    let writer: String
    var imageId: String?
    let missions: [Mission]
    let rewards: [Reward]
    let score: Int
    let expireDate: String
    var type, target: String
    var mainImageId: String?
    let popularYn: Bool
    
    func toPostQuestRequest() -> PostQuestRequest {
        return PostQuestRequest(
            writer: self.writer,
            imageId: imageId ?? "",
            missions: self.missions,
            rewards: self.rewards,
            score: self.score,
            expireDate: self.expireDate,
            type: self.type,
            target: self.target,
            mainImageId: self.mainImageId ?? "", // 메인 이미지는 옵셔널 가능
            popularYn: self.popularYn
        )
    }
}
