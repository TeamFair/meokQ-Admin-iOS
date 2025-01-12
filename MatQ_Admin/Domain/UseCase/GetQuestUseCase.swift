//
//  GetQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine
import UIKit

protocol GetQuestUseCaseInterface {
    func execute(page: Int) -> AnyPublisher<[Quest], NetworkError>
}

final class GetQuestUseCase: GetQuestUseCaseInterface {
    let questRepository: QuestRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.questRepository = questRepository
        self.imageRepository = imageRepository
    }
    
    func execute(page: Int) -> AnyPublisher<[Quest], NetworkError> {
        let request = GetQuestRequest(page: page)
        return questRepository.getQuestList(request: request)
            .flatMap { quests in
                let questsWithImages = quests.map { quest -> AnyPublisher<Quest, NetworkError> in
                    self.updateQuestImages(quest: quest)
                }
                return Publishers.MergeMany(questsWithImages)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // MARK: - 이미지 업데이트 처리
    private func updateQuestImages(quest: Quest) -> AnyPublisher<Quest, NetworkError> {
        let logoImagePublisher = updateImage(
            for: quest,
            imageId: quest.logoImageId,
            keyPath: \.image
        )
        
        let mainImagePublisher = updateImage(
            for: quest,
            imageId: quest.mainImageId,
            keyPath: \.mainImage
        )
        
        return logoImagePublisher
            .flatMap { questWithLogo in
                mainImagePublisher.map { questWithMain in
                    var updatedQuest = questWithLogo
                    updatedQuest.mainImage = questWithMain.mainImage
                    return updatedQuest
                }
            }
            .eraseToAnyPublisher()
    }

    private func updateImage(
        for quest: Quest,
        imageId: String?,
        keyPath: WritableKeyPath<Quest, UIImage?>
    ) -> AnyPublisher<Quest, NetworkError> {
        guard let imageId = imageId, !imageId.isEmpty else {
            return Just(quest)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        let imageRequest = GetImageRequest(imageId: imageId)
        return imageRepository.getImage(request: imageRequest)
            .map { image in
                var updatedQuest = quest
                updatedQuest[keyPath: keyPath] = image.resizeImage(newWidth: UIImageSize.medium.value)
                return updatedQuest
            }
            .catch { _ in
                Just(quest)
                    .setFailureType(to: NetworkError.self)
            }
            .eraseToAnyPublisher()
    } 
}
