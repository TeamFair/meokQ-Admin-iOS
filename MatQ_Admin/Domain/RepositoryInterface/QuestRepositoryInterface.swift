//
//  QuestRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine

protocol QuestRepositoryInterface {
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[GetQuestResponseData], NetworkError>
    func postQuest(request: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<DeleteQuestResponse, NetworkError>
}
