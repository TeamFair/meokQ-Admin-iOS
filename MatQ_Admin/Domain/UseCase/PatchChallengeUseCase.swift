//
//  PatchChallengeUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Combine
import Foundation

protocol PatchChallengeUseCaseInterface {
    func execute(challengeId: String) -> AnyPublisher<PatchChallengeResponse, NetworkError>
}

final class PatchChallengeUseCase: PatchChallengeUseCaseInterface {
    let challengeRepository: ChallengeRepositoryInterface
    
    init(challengeRepository: ChallengeRepositoryInterface) {
        self.challengeRepository = challengeRepository
    }
    
    func execute(challengeId: String) -> AnyPublisher<PatchChallengeResponse, NetworkError> {
        // status ==> APPROVED,REPORTED,REJECTED
        let request = PatchChallengeRequest(challengeId: challengeId, status: "APPROVED")
        
        return challengeRepository.patchChallenge(request: request)
    }
}
