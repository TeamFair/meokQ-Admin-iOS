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
    func getQuestList(request: GetQuestRequest) async -> Result<[GetQuestResponseData], NetworkError>
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
}

struct QuestService: QuestServiceInterface {
    func getQuestList(request: GetQuestRequest) async -> Result<[GetQuestResponseData], NetworkError> {
        let taskRequest = AF.request(QuestTarget.getQuest(request))
            .validate(statusCode: 200..<300)
            .serializingDecodable(ResponseWithPage<[GetQuestResponseData]>.self)
        
        switch await taskRequest.result {
        case .success(let response):
            return .success(response.data)
        case .failure:
            return .failure(NetworkError.serverError)
        }
    }
    
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError> {
        AF.request(QuestTarget.postQuest(request))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: PostQuestResponse.self)
            .value()
            .print("", to: nil)
            .mapError { error in
                print(error.localizedDescription)
                return NetworkError.serverError
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError> {
        return AF.request(QuestTarget.deleteQuest(request))
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
