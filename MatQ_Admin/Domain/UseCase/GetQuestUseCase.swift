//
//  GetQuestUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine

protocol GetQuestUseCaseInterface {
    func getQuestList(page: Int) async -> AnyPublisher<[Quest], NetworkError>
}

final class GetQuestUseCase: GetQuestUseCaseInterface {
    
    let questRepository: QuestRepositoryInterface
    
    init(questRepository: QuestRepositoryInterface) {
        self.questRepository = questRepository
    }
    
    func getQuestList(page: Int) async -> AnyPublisher<[Quest], NetworkError> {
        return await self.questRepository.getQuestList(page: page)
            .map { questResponseImageDataList in
                questResponseImageDataList.map { Quest(quest: $0) }
            }
            .eraseToAnyPublisher()
    }
}
