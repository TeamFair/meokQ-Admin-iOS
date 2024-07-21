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
    
    func getQuestList(page: Int) async -> AnyPublisher<[GetQuestResponseImageData], NetworkError> {
        let request = GetQuestRequest(page: page)
        
        do {
            let questListResponse = await self.questService.getQuestList(request: request)
            let mappedData = try await mapImagesAsync(questListResponse)
            return Result.Publisher(.success(mappedData))
                .eraseToAnyPublisher()
        } catch {
            return Result.Publisher(.failure(NetworkError.unknownError))
                .eraseToAnyPublisher()
        }
    }
    
    private func loadImage(imageId: String) async -> UIImage? {
        guard imageId != "" else  { return nil }
        
        let imageResponse = await self.imageService.getImage(request: .init(imageId: imageId))
        
        switch imageResponse {
        case .success(let uiImage):
            return uiImage
        case .failure:
            return nil
        }
    }
    
    private func mapImagesAsync(_ questListResponse: Result<[GetQuestResponseData], NetworkError>) async throws -> [GetQuestResponseImageData] {
        switch questListResponse {
        case .success(let res):
            var modifiedResponse = [GetQuestResponseImageData]()
            try await withThrowingTaskGroup(of: GetQuestResponseImageData.self) { group in
                for quest in res {
                    group.addTask {
                        let uiImage = await self.updateQuestImage(quest)
                        var modifiedQuest = GetQuestResponseImageData(quest: quest)
                        modifiedQuest.image = uiImage
                        return modifiedQuest
                    }
                }
            
                for try await modifiedQuest in group {
                    modifiedResponse.append(modifiedQuest)
                }
            }
            return modifiedResponse
        case .failure(let error):
            throw error
        }
    }
    private func updateQuestImage(_ quest: GetQuestResponseData) async -> UIImage? {
        guard let imageId = quest.imageId else { return nil }
        let image = await self.loadImage(imageId: imageId)
        return image
    }
    
    func postQuest(questRequest: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError> {
        let response = self.questService.postQuest(request: questRequest)
        return response
    }
    
    func deleteQuest(questRequest: DeleteQuestRequest) -> AnyPublisher<DeleteQuestResponse, NetworkError> {
        let response = self.questService.deleteQuest(request: questRequest)
        return response
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
