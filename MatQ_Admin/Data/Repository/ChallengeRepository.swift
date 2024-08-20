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
    
    func getChallengeList(request: GetChallengeRequest) -> AnyPublisher<[GetChallengeResponseData], NetworkError> {
        challengeDataSource.getChallengeList(request: request)
    }
    
    func patchChallenge(request: PatchChallengeRequest) -> AnyPublisher<PatchChallengeResponse, NetworkError> {
        challengeDataSource.patchChallenge(request: request)
    }
    
    func deleteChallenge(request: DeleteChallengeRequest) -> AnyPublisher<DeleteChallengeResponse, NetworkError> {
        challengeDataSource.deleteChallenge(request: request)
    }
}
