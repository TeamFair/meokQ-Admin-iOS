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
        request: PostQuestRequestModel,
        image: UIImage?,
        mainImage: UIImage?
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
        request: PostQuestRequestModel,
        image: UIImage?,
        mainImage: UIImage?
    ) -> AnyPublisher<Void, NetworkError> {
        // 메인 이미지가 있을 경우 메인 이미지 업로드 -> 추가 로직 실행
        if let mainImage = mainImage {
            return uploadImage(image: mainImage)
                .flatMap { mainImageId in
                    var updatedRequest = request
                    updatedRequest.mainImageId = mainImageId
                    return self.handleQuestCreation(request: updatedRequest, image: image)
                }
                .eraseToAnyPublisher()
        }
        // 메인 이미지가 없는 경우 처리
        return handleQuestCreation(request: request, image: image)
    }
    
    // 퀘스트 생성 로직 처리
    private func handleQuestCreation(
        request: PostQuestRequestModel,
        image: UIImage?
    ) -> AnyPublisher<Void, NetworkError> {
        // 이미지 ID가 이미 있을 경우 바로 퀘스트 생성 (== 기본 로고 이미지)
        if let imageId = request.imageId, !imageId.isEmpty {
            return createQuest(request: request)
        }
        // 이미지 업로드가 필요한 경우
        else if let image = image {
            return uploadImage(image: image)
                .flatMap { newImageId in
                    var updatedRequest = request
                    updatedRequest.imageId = newImageId
                    return self.createQuest(request: updatedRequest)
                }
                .eraseToAnyPublisher()
        }
        // 이미지 데이터가 유효하지 않을 경우
        else {
            return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
        }
    }
    
    // 이미지 업로드 메서드
    private func uploadImage(image: UIImage) -> AnyPublisher<String, NetworkError> {
        imageRepository.postImage(image: image)
    }
    
    // 퀘스트 생성 메서드
    private func createQuest(request: PostQuestRequestModel) -> AnyPublisher<Void, NetworkError> {
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
    let type, target: String
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
