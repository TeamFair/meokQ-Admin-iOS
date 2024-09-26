//
//  PutQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 9/24/24.
//

import Combine
import UIKit

fileprivate struct QuestRequest {
    let questId: String
    let writer: String
    var imageId: String?
    let missions: [Mission]
    let rewards: [Reward]
    let score: Int
    let expireDate: String
    
    func toPutQuestRequest() -> PutQuestRequest? {
        guard let imageId = imageId else { return nil }
        return PutQuestRequest(
            questId: self.questId,
            quest: .init(writer: self.writer, imageId: imageId, missions: self.missions, rewards: self.rewards, score: self.score, expireDate: self.expireDate)
        )
    }
}

protocol PutQuestUseCaseInterface {
    func execute(questId: String, writer: String, image: UIImage, imageId: String, missionTitle: String, rewardList: [Reward], score: Int, expireDate: String, imageUpdated: Bool) -> AnyPublisher<Void, NetworkError>
}

final class PutQuestUseCase: PutQuestUseCaseInterface {
    let questRepository: QuestRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.questRepository = questRepository
        self.imageRepository = imageRepository
    }
    
    func execute(questId: String, writer: String, image: UIImage, imageId: String, missionTitle: String, rewardList: [Reward], score: Int, expireDate: String, imageUpdated: Bool) -> AnyPublisher<Void, NetworkError> {
        // TODO: PUT이니 수정
        let request = QuestRequest(questId: questId,
                                   writer: writer,
                                   imageId: imageId,
                                   missions: [.init(content: missionTitle)],
                                   rewards: rewardList,
                                   score: score,
                                   expireDate: expireDate)
        
        if imageUpdated {
            // 새로운 이미지면 퀘스트 생성 TODO: 기존 이미지 삭제 처리or관리
            return uploadImageAndPutQuest(image: image, request: request)
        } else {
            // 기존 이미지면 바로 퀘스트 생성
            return createQuest(request: request)
        }
    }
    
    private func uploadImageAndPutQuest(image: UIImage, request: QuestRequest) -> AnyPublisher<Void, NetworkError> {
        imageRepository.postImage(image: image)
            .flatMap { newImageId in
                var request = request
                request.imageId = newImageId
                return self.createQuest(request: request)
            }
            .eraseToAnyPublisher()
    }
    
    /// 퀘스트 생성 메서드
    private func createQuest(request: QuestRequest) -> AnyPublisher<Void, NetworkError> {
        guard let request = request.toPutQuestRequest() else {
            return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
        }
        return questRepository.putQuest(request: request).eraseToAnyPublisher()
    }
}
