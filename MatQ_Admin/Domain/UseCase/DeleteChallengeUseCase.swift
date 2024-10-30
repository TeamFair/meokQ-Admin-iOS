//
//  DeleteChallengeUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Combine
import Foundation

protocol DeleteChallengeUseCaseInterface {
    func execute(challengeId: String, imageId: String?) -> AnyPublisher<Void, NetworkError>
}

final class DeleteChallengeUseCase: DeleteChallengeUseCaseInterface {
    let challengeRepository: ChallengeRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(challengeRepository: ChallengeRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.challengeRepository = challengeRepository
        self.imageRepository = imageRepository
    }
    
    /// #62 PR 로직 설명 참고
    func execute(challengeId: String, imageId: String?) -> AnyPublisher<Void, NetworkError> {
        let challengeRequest = DeleteChallengeRequest(challengeId: challengeId)
        
        if let imageId = imageId {
            let imageRequest = DeleteImageRequest(imageId: imageId)
            
            return imageRepository.deleteImage(request: imageRequest)
                .map { _ in }
                .catch { error -> AnyPublisher<Void, NetworkError> in
                    // 이미지 삭제 실패하더라도 406에러(NOT_FOUND_DATA)인 경우는 챌린지 삭제 작업 수행
                    if case let NetworkError.error((_, status, _)) = error, status == "NOT_FOUND_DATA" {
                        return Just(())
                            .setFailureType(to: NetworkError.self)
                            .eraseToAnyPublisher()
                    } else {
                        return Fail(error: error)
                            .eraseToAnyPublisher()
                    }
                }
                .flatMap { _ in  // 이미지 삭제 성공 후 챌린지 삭제 작업 수행
                    return self.challengeRepository.deleteChallenge(request: challengeRequest)
                }
                .eraseToAnyPublisher()
        } else {
            return challengeRepository.deleteChallenge(request: challengeRequest)
                .mapError { _ in NetworkError.unknownError }
                .eraseToAnyPublisher()
        }
    }
}
