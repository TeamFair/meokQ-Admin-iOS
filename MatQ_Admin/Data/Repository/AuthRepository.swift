//
//  AuthRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 12/27/24.
//

import Alamofire
import Combine

protocol AuthRepositoryInterface {
    func postAuth(request: PostAuthRequest) -> AnyPublisher<Void, NetworkError>
}

final class AuthRepository: AuthRepositoryInterface {
    private let networkService: NetworkServiceInterface
    
    init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }
    
    func postAuth(request: PostAuthRequest) -> AnyPublisher<Void, NetworkError> {
        networkService.request(AuthTarget.login(request), as: Response<PostAuthResponse>.self)
            .tryMap { response in
                dump(response)
                guard let token = response.data.authorization else {
                    throw NetworkError.invalidResponse // 에러 처리
                }
                // Keychain에 토큰 저장
                // print(token)
                KeychainHelper.shared.save(key: "AdminAuthToken", value: token)
            }
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return .unknownError
                }
            }
            .eraseToAnyPublisher()
    }
}
