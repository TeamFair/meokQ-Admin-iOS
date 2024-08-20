//
//  ChallengeRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Combine

protocol ChallengeRepositoryInterface {
    func getChallengeList(request: GetChallengeRequest) -> AnyPublisher<[GetChallengeResponseData], NetworkError>
    func patchChallenge(request: PatchChallengeRequest) -> AnyPublisher<PatchChallengeResponse, NetworkError>
    func deleteChallenge(request: DeleteChallengeRequest) -> AnyPublisher<DeleteChallengeResponse, NetworkError>
}
