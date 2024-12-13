//
//  PostQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine
import UIKit

fileprivate struct QuestRequest {
    let writer: String
    var imageId: String?
    let missions: [Mission]
    let rewards: [Reward]
    let score: Int
    let expireDate: String
    let type, target: String
    
    func toPostQuestRequest() -> PostQuestRequest? {
        guard let imageId = imageId else { return nil }
        let request = PostQuestRequest(writer: self.writer, imageId: imageId, missions: self.missions, rewards: self.rewards, score: self.score, expireDate: self.expireDate, type: self.type, target: self.target)
        
        return request
    }
}

protocol PostQuestUseCaseInterface {
    func execute(
        writer: String,
        image: UIImage?,
        imageId: String?,
        missionTitle: String,
        questTarget: QuestRepeatTarget,
        questType: QuestType,
        rewardList: [Reward],
        score: Int,
        expireDate: String
    ) -> AnyPublisher<Void, NetworkError>
}

final class PostQuestUseCase: PostQuestUseCaseInterface {
    
    let questRepository: QuestRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.questRepository = questRepository
        self.imageRepository = imageRepository
    }
    
    func execute(
        writer: String,
        image: UIImage?,
        imageId: String?,
        missionTitle: String,
        questTarget: QuestRepeatTarget,
        questType: QuestType,
        rewardList: [Reward],
        score: Int,
        expireDate: String
    ) -> AnyPublisher<Void, NetworkError> {
        let request = QuestRequest(
            writer: writer,
            imageId: imageId,
            missions: [.init(content: missionTitle)],
            rewards: rewardList,
            score: score,
            expireDate: expireDate,
            type: questType.rawValue.uppercased(),
            target: questTarget.rawValue.uppercased()
        )
        if let _ = imageId {
            // imageId가 있을 때 바로 퀘스트 생성
            return createQuest(request: request)
        } else if let image = image {
            // 이미지를 업로드하고 퀘스트를 생성
            return uploadImageAndPostQuest(image: image, request: request)
        } else {
            return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
        }
    }
    
    private func uploadImageAndPostQuest(image: UIImage, request: QuestRequest) -> AnyPublisher<Void, NetworkError> {
        return imageRepository.postImage(image: image)
            .flatMap { newImageId in
                var request = request
                request.imageId = newImageId
                return self.createQuest(request: request)
            }
            .eraseToAnyPublisher()
    }
    
    // 퀘스트 생성 메서드
    private func createQuest(request: QuestRequest) -> AnyPublisher<Void, NetworkError> {
        guard let request = request.toPostQuestRequest() else {
            return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
        }
        return questRepository.postQuest(request: request).eraseToAnyPublisher()
    }
}
