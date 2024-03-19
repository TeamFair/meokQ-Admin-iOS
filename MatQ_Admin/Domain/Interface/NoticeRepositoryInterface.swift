//
//  NoticeRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Combine

protocol NoticeRepositoryInterface {
    func getNotice(target: NoticeTargetType, page: Int) async -> AnyPublisher<[Notice], NetworkError>
    func postNotice(title: String, content: String, target: NoticeTargetType) async -> AnyPublisher<Bool, NetworkError>
    func deleteNotice(noticeId: String) async -> AnyPublisher<Bool, NetworkError>
}
