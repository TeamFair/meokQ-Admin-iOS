//
//  MockChallengeRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 10/30/24.
//

import Combine
import Foundation

final class MockChallengeRepository: ChallengeRepositoryInterface {
    var result: Result<Void, NetworkError>?
    var challengeResult: Result<[Challenge], NetworkError>?
    var isDeleteChallengeCalled = false

    func getChallengeList(request: GetChallengeRequest) -> AnyPublisher<[Challenge], NetworkError> {
        if let result = challengeResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func patchChallenge(request: PatchChallengeRequest) -> AnyPublisher<Void, NetworkError> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func deleteChallenge(request: DeleteChallengeRequest) -> AnyPublisher<Void, NetworkError> {
        isDeleteChallengeCalled = true
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
}
