//
//  QuestRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Combine

protocol QuestRepositoryInterface {
    func getQuestList(request: GetQuestRequest) -> AnyPublisher<[Quest], NetworkError>
    func postQuest(request: PostQuestRequest) -> AnyPublisher<Void, NetworkError>
    func deleteQuest(request: DeleteQuestRequest) -> AnyPublisher<Void, NetworkError>
}
