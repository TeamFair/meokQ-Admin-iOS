//
//  MockQuestRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 10/23/24.
//

import Combine

final class MockQuestRepository: QuestRepositoryInterface {
    var result: Result<Void, NetworkError>?
    var questResult: Result<[Quest], NetworkError>?

    
    func putQuest(request: PutQuestRequest) -> AnyPublisher<Void, NetworkError> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[Quest], NetworkError> {
        if let result = questResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func postQuest(request: PostQuestRequest) -> AnyPublisher<Void, NetworkError> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<Void, NetworkError> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
}
