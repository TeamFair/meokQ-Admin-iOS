//
//  QuestRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine

protocol QuestRepositoryInterface {
    func getQuestList(page: Int) -> AnyPublisher<[GetQuestResponseImageData], NetworkError>
    func postQuest(questRequest: PostQuestRequest) -> AnyPublisher<PostQuestResponse, NetworkError>
    func deleteQuest(questRequest: DeleteQuestRequest) -> AnyPublisher<DeleteQuestResponse, NetworkError>
}
