//
//  ChallengeDataSource.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Alamofire
import Combine
import Foundation

protocol ChallengeDataSourceInterface {
    func getChallengeList(request: GetChallengeRequest) -> AnyPublisher<[GetChallengeResponseData], NetworkError>
    func patchChallenge(request: PatchChallengeRequest) -> AnyPublisher<PatchChallengeResponse, NetworkError>
    func deleteChallenge(request: DeleteChallengeRequest) -> AnyPublisher<DeleteChallengeResponse, NetworkError>
}

struct ChallengeDataSource: ChallengeDataSourceInterface {
    private let networkService: NetworkServiceInterface
    
    init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }
    
    func getChallengeList(request: GetChallengeRequest) -> AnyPublisher<[GetChallengeResponseData], NetworkError> {
        networkService.request(ChallengeTarget.getChallenge(request), as: GetChallengeResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    func patchChallenge(request: PatchChallengeRequest) -> AnyPublisher<PatchChallengeResponse, NetworkError> {
        networkService.request(ChallengeTarget.patchChallenge(request), as: PostQuestResponse.self)
    }

    func deleteChallenge(request: DeleteChallengeRequest) -> AnyPublisher<DeleteChallengeResponse, NetworkError> {
        networkService.request(ChallengeTarget.deleteChallenge(request), as: DeleteQuestResponse.self)
    }
}
