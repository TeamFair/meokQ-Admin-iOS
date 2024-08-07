//
//  PostQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine
import UIKit

protocol PostQuestUseCaseInterface {
    func postQuest(writer: String, image: UIImage?, imageId: String?, missionTitle: String, quantity: Int, expireDate: String) -> AnyPublisher<PostQuestResponse, NetworkError>
}

final class PostQuestUseCase: PostQuestUseCaseInterface {
    
    let questRepository: QuestRepositoryInterface
    let imageService: ImageServiceInterface // TOBE..이미지 데이터소스..
    
    init(questRepository: QuestRepositoryInterface, imageService: ImageServiceInterface) {
        self.questRepository = questRepository
        self.imageService = imageService
    }
    
    // TODO: 여기서 PostQuestResponse 이 모델을 알아야하는지
    func postQuest(writer: String, image: UIImage?, imageId: String?, missionTitle: String, quantity: Int, expireDate: String) -> AnyPublisher<PostQuestResponse, NetworkError> {
        // image가 없으면 imageId를 사용
        if let image = image {
            return uploadImageAndPostQuest(
                image: image,
                writer: writer,
                missionTitle: missionTitle,
                quantity: quantity,
                expireDate: expireDate
            )
        } else if let imageId = imageId {
            return self.questRepository.postQuest(
                questRequest: PostQuestRequest(
                    writer: writer,
                    imageId: imageId,
                    missions: [.init(content: missionTitle)],
                    rewards: [.init(quantity: quantity)],
                    expireDate: expireDate
                )
            )
            .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
        }
    }
    
    private func uploadImageAndPostQuest(image: UIImage, writer: String, missionTitle: String, quantity: Int, expireDate: String) -> AnyPublisher<PostQuestResponse, NetworkError> {
        var uiImage = image
        if image.size.width > 1500 || image.size.height > 1500 {
            print("RESIZE IMAGE \(image.size.width) \(image.size.height)")
            guard let downSampledImage = image.downSample(scale: 0.5) else {
                return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
            }
            uiImage = downSampledImage
        }
        
        let compressionQualities: [CGFloat] = [0.4, 0.2, 0.05, 0.002]
        
        return compressionQualities.publisher
            .flatMap { quality in
                // 이미지 압축
                let imageData = uiImage.jpegData(compressionQuality: quality) ?? Data()
                // 이미지 업로드
                return self.imageService.postImage(request: PostImageRequest(data: imageData))
                    .map { newImageId in
                        (newImageId, quality)
                    }
                    .mapError { error in
                        NetworkError.serverError
                    }
                    .eraseToAnyPublisher()
            }
            .first()
            .flatMap { newImageId, _ in
                // 퀘스트 생성
                self.questRepository.postQuest(
                    questRequest: PostQuestRequest(
                        writer: writer,
                        imageId: newImageId,
                        missions: [.init(content: missionTitle)],
                        rewards: [.init(quantity: quantity)],
                        expireDate: expireDate
                    )
                )
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
