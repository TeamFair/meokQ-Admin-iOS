//
//  GetQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine

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
                let questsWithImages = quests
                    .map { $0.toDomain(image: nil) }
                    .map { quest -> AnyPublisher<Quest, NetworkError> in
                        
                        // imageId가 없을 경우, 원래의 quest를 반환
                        guard let imageId = quest.logoImageId, !imageId.isEmpty else {
                            return Just(quest)
                                .setFailureType(to: NetworkError.self)
                                .eraseToAnyPublisher()
                        }
                        
                        // imageId가 있는 경우, 이미지를 로드하고 quest를 업데이트
                        let imageRequest = GetImageRequest(imageId: imageId)
                        
                        return self.imageRepository.getImage(request: imageRequest)
                            .map { image in
                                var updatedQuest = quest
                                updatedQuest.image = image
                                return updatedQuest
                            }
                            .catch { _ in
                                Just(quest)
                                    .setFailureType(to: NetworkError.self)
                            }
                            .eraseToAnyPublisher()
                    }
                
                return Publishers.MergeMany(questsWithImages)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
