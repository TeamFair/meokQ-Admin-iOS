//
//  QuestRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine
import UIKit

final class QuestRepository: QuestRepositoryInterface {
    
    let questService: QuestServiceInterface
    let imageService: ImageServiceInterface
    
    init(questService: QuestServiceInterface, imageService: ImageServiceInterface) {
        self.questService = questService
        self.imageService = imageService
    }
    
    func getQuestList(page: Int) -> AnyPublisher<[GetQuestResponseImageData], NetworkError> {
        let request = GetQuestRequest(page: page)
        
        return questService.getQuestList(request: request)
            .flatMap { [weak self] questListResponse -> AnyPublisher<[GetQuestResponseImageData], NetworkError> in
                guard let self = self else {
                    return Fail(error: .unknownError)
                        .eraseToAnyPublisher()
                }
                return self.mapImages(questListResponse)
            }
            .eraseToAnyPublisher()
    }
    
    private func loadImage(imageId: String) -> AnyPublisher<UIImage?, Never> {
        guard !imageId.isEmpty else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return imageService.getImage(request: .init(imageId: imageId))
            .map { uiImage in
                return Optional(uiImage) // UIImage를 UIImage?로 변환
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func mapImages(_ questListResponse: [GetQuestResponseData]) -> AnyPublisher<[GetQuestResponseImageData], NetworkError> {
        let publishers = questListResponse.map { quest -> AnyPublisher<GetQuestResponseImageData, Never> in
            return self.updateQuestImage(quest)
                .map { uiImage in
                    var modifiedQuest = GetQuestResponseImageData(quest: quest)
                    modifiedQuest.image = uiImage
                    return modifiedQuest
                }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    private func updateQuestImage(_ quest: GetQuestResponseData) -> AnyPublisher<UIImage?, Never> {
        guard let imageId = quest.imageId else {
            return Just(nil).eraseToAnyPublisher()
        }
        return loadImage(imageId: imageId)
    }
    
    func postQuest(questRequest: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError> {
        questService.postQuest(request: questRequest)
    }
    
    func deleteQuest(questRequest: DeleteQuestRequest) -> AnyPublisher<DeleteQuestResponse, NetworkError> {
        questService.deleteQuest(request: questRequest)
    }
}

struct GetQuestResponseImageData {
    let questId: String
    let writer: String
    let quantity: Int
    let missionTitle: String
    let status: String
    let expireDate: String
    var image: UIImage?
    let imageId: String?
    
    init(quest: GetQuestResponseData) {
        self.questId = quest.questId
        self.writer = quest.writer
        self.quantity = quest.quantity
        self.missionTitle = quest.missionTitle
        self.status = quest.status
        self.expireDate = quest.expireDate
        self.image = nil
        self.imageId = quest.imageId
    }
    
    init(questId: String, writer: String, quantity: Int, missionTitle: String, status: String, expireDate: String, image: UIImage, imageId: String) {
        self.questId = questId
        self.writer = writer
        self.quantity = quantity
        self.missionTitle = missionTitle
        self.status = status
        self.expireDate = expireDate
        self.image = image
        self.imageId = imageId
    }
}
