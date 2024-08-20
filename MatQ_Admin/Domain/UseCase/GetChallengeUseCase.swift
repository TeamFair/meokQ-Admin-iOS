//
//  GetChallengeUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Combine
import Foundation

protocol GetChallengeUseCaseInterface {
    func execute(page: Int) -> AnyPublisher<[Challenge], NetworkError>
}

final class GetChallengeUseCase: GetChallengeUseCaseInterface {
    let challengeRepository: ChallengeRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(challengeRepository: ChallengeRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.challengeRepository = challengeRepository
        self.imageRepository = imageRepository
    }
    
    func execute(page: Int) -> AnyPublisher<[Challenge], NetworkError> {
        let request = GetChallengeRequest(page: page)
        
        return challengeRepository.getChallengeList(request: request)
            .flatMap { challenges in
                let questsWithImages = challenges
                    .map { challenge -> AnyPublisher<Challenge, NetworkError> in
                        
                        // imageId가 없을 경우, 원래의 quest를 반환
                        guard let imageId = challenge.receiptImageId, !imageId.isEmpty else {
                            return Just(challenge)
                                .setFailureType(to: NetworkError.self)
                                .eraseToAnyPublisher()
                        }
                        
                        // imageId가 있는 경우, 이미지를 로드하고 quest를 업데이트
                        let imageRequest = GetImageRequest(imageId: imageId)
                        
                        return self.imageRepository.getImage(request: imageRequest)
                            .map { image in
                                var updatedQuest = challenge
                                updatedQuest.image = image
                                return updatedQuest
                            }
                            .catch { _ in
                                Just(challenge)
                                    .setFailureType(to: NetworkError.self)
                            }
                            .eraseToAnyPublisher()
                    }
                
                return Publishers.MergeMany(questsWithImages)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
