//
//  ChallengeRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Combine
import UIKit

final class ChallengeRepository: ChallengeRepositoryInterface {
    let challengeDataSource: ChallengeDataSourceInterface
    
    init(challengeDataSource: ChallengeDataSourceInterface) {
        self.challengeDataSource = challengeDataSource
    }
    
    func getChallengeList(request: GetChallengeRequest) -> AnyPublisher<[Challenge], NetworkError> {
        challengeDataSource.getChallengeList(request: request)
            .map { response in
                response.map { $0.toDomain(image: nil) }
            }
            .eraseToAnyPublisher()
    }
    
    func patchChallenge(request: PatchChallengeRequest) -> AnyPublisher<Void, NetworkError> {
        challengeDataSource.patchChallenge(request: request)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func deleteChallenge(request: DeleteChallengeRequest) -> AnyPublisher<Void, NetworkError> {
        challengeDataSource.deleteChallenge(request: request)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
