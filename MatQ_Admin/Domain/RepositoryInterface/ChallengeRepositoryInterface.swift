//
//  ChallengeRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Combine

protocol ChallengeRepositoryInterface {
    func getChallengeList(request: GetChallengeRequest) -> AnyPublisher<[Challenge], NetworkError>
    func patchChallenge(request: PatchChallengeRequest) -> AnyPublisher<Void, NetworkError>
    func deleteChallenge(request: DeleteChallengeRequest) -> AnyPublisher<Void, NetworkError>
}
