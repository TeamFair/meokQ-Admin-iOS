//
//  QuestService.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Alamofire
import Combine
import Foundation

protocol QuestServiceInterface {
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[GetQuestResponseData], NetworkError>
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
}

struct QuestService: QuestServiceInterface {
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[GetQuestResponseData], NetworkError> {
        AF.request(QuestTarget.getQuest(request))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: ResponseWithPage<[GetQuestResponseData]>.self)
            .tryMap { response in
                guard let value = response.value else {
                    throw NetworkError.serverError
                }
                return value.data
            }
            .mapError { _ in NetworkError.serverError }
            .eraseToAnyPublisher()
    }
    
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError> {
        AF.request(QuestTarget.postQuest(request))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: PostQuestResponse.self)
            .value()
            .mapError { error in
                print(error.localizedDescription)
                return NetworkError.serverError
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError> {
        AF.request(QuestTarget.deleteQuest(request))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: DeleteQuestResponse.self)
            .value()
            .mapError { error in
                print(error.localizedDescription)
                return NetworkError.serverError
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
