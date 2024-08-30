//
//  DeleteChallengeUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Combine
import Foundation

protocol DeleteChallengeUseCaseInterface {
    func execute(challengeId: String) -> AnyPublisher<Void, NetworkError>
}

final class DeleteChallengeUseCase: DeleteChallengeUseCaseInterface {
    let challengeRepository: ChallengeRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(challengeRepository: ChallengeRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.challengeRepository = challengeRepository
        self.imageRepository = imageRepository
    }
    
    func execute(challengeId: String) -> AnyPublisher<Void, NetworkError> {
        let request = DeleteChallengeRequest(challengeId: challengeId)
        
        return challengeRepository.deleteChallenge(request: request)
    }
}
