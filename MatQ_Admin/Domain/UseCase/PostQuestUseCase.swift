//
//  PostQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine
import UIKit

protocol PostQuestUseCaseInterface {
    func execute(writer: String, image: UIImage?, imageId: String?, missionTitle: String, rewardList: [Reward], expireDate: String) -> AnyPublisher<Void, NetworkError>
}

final class PostQuestUseCase: PostQuestUseCaseInterface {
    
    let questRepository: QuestRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.questRepository = questRepository
        self.imageRepository = imageRepository
    }
    
    // TODO: 책임 분리
    func execute(writer: String, image: UIImage?, imageId: String?, missionTitle: String, rewardList: [Reward], expireDate: String) -> AnyPublisher<Void, NetworkError> {
        // image가 없으면 imageId를 사용
        if let image = image {
            return uploadImageAndPostQuest(
                image: image,
                writer: writer,
                missionTitle: missionTitle,
                rewardList: rewardList,
                expireDate: expireDate
            )
        } else if let imageId = imageId {
            return self.questRepository.postQuest(
                request: PostQuestRequest(
                    writer: writer,
                    imageId: imageId,
                    missions: [.init(content: missionTitle)],
                    rewards: rewardList,
                    expireDate: expireDate
                )
            )
            .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
        }
    }
    
    private func uploadImageAndPostQuest(image: UIImage, writer: String, missionTitle: String, rewardList: [Reward], expireDate: String) -> AnyPublisher<Void, NetworkError> {
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
                return self.imageRepository.postImage(request: PostImageRequest(data: imageData))
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
                    request: PostQuestRequest(
                        writer: writer,
                        imageId: newImageId,
                        missions: [.init(content: missionTitle)],
                        rewards: rewardList,
                        expireDate: expireDate
                    )
                )
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
