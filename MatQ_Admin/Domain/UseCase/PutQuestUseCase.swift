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
    let target: String
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
        request: PutQuestRequestModel,
        image: UIImage?,
        mainImage: UIImage?,
        imageUpdated: Bool,
        mainImageUpdated: Bool
    ) -> AnyPublisher<Void, NetworkError>
}

final class PutQuestUseCase: PutQuestUseCaseInterface {
    let questRepository: QuestRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.questRepository = questRepository
        self.imageRepository = imageRepository
    }
    
    func execute(
        request: PutQuestRequestModel,
        image: UIImage?,
        mainImage: UIImage?,
        imageUpdated: Bool,
        mainImageUpdated: Bool
    ) -> AnyPublisher<Void, NetworkError> {
        var updatedRequestPublisher: AnyPublisher<PutQuestRequestModel, NetworkError> = Just(request)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
        if mainImageUpdated, let mainImage = mainImage {
            print("메인이미지 업데이트 예정")
            updatedRequestPublisher = updateImage(for: request, with: mainImage, keyPath: \.mainImageId)
        }
        
        if imageUpdated, let image = image {
            print("작성자이미지 업데이트 예정")
            updatedRequestPublisher = updatedRequestPublisher
                .flatMap { updatedRequest in
                    self.updateImage(for: updatedRequest, with: image, keyPath: \.writerImageId)
                }
                .eraseToAnyPublisher()
        }
        
        return updatedRequestPublisher
            .flatMap { updatedRequest in
                self.updateQuest(request: updatedRequest)
            }
            .eraseToAnyPublisher()
    }
    
    // 공통 이미지 업데이트 메서드
    private func updateImage(
        for request: PutQuestRequestModel,
        with image: UIImage,
        keyPath: WritableKeyPath<PutQuestRequestModel, String?>
    ) -> AnyPublisher<PutQuestRequestModel, NetworkError> {
        uploadImage(image: image)
            .map { newImageId in
                var updatedRequest = request
                updatedRequest[keyPath: keyPath] = newImageId
                return updatedRequest
            }
            .eraseToAnyPublisher()
    }
    
    // 이미지 업로드
    private func uploadImage(image: UIImage) -> AnyPublisher<String, NetworkError> {
        imageRepository.postImage(image: image)
    }
    
    // 퀘스트 업데이트
    private func updateQuest(request: PutQuestRequestModel) -> AnyPublisher<Void, NetworkError> {
        guard let validRequest = request.toPutQuestRequest() else {
            return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
        }
        return questRepository.putQuest(request: validRequest).eraseToAnyPublisher()
    }
}
