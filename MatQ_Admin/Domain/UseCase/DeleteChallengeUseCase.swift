//
//  DeleteChallengeUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Combine
import Foundation

protocol DeleteChallengeUseCaseInterface {
    func execute(challengeId: String) -> AnyPublisher<DeleteChallengeResponse, NetworkError>
}

final class DeleteChallengeUseCase: DeleteChallengeUseCaseInterface {
    let challengeRepository: ChallengeRepositoryInterface
    
    init(challengeRepository: ChallengeRepositoryInterface) {
        self.challengeRepository = challengeRepository
    }
    
    func execute(challengeId: String) -> AnyPublisher<DeleteChallengeResponse, NetworkError> {
        let request = DeleteChallengeRequest(challengeId: challengeId)
        
        return challengeRepository.deleteChallenge(request: request)
    }
}
