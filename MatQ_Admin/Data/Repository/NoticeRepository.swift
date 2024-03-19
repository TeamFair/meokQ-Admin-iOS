//
//  NoticeRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Combine

enum NoticeTargetType: String, CaseIterable {
    case ALL
    case BOSS
    case CUSTOMER
    case ADMIN
}

final class NoticeRepository: NoticeRepositoryInterface {
  
    let noticeService: NoticeServiceInterface
    
    init(noticeService: NoticeServiceInterface) {
        self.noticeService = noticeService
    }
    
    func getNotice(target: NoticeTargetType, page: Int) async -> AnyPublisher<[Notice], NetworkError> {
        let request = GetNoticeRequest(page: page, target: target.rawValue)
        let result = await self.noticeService.getNoticeList(request: request)
        
        return Future<[Notice], NetworkError> { promise in
            switch result {
            case .success(let notices):
                promise(.success(notices))
            case .failure:
                promise(.failure(NetworkError.serverError))
            }
        }.eraseToAnyPublisher()
    }
    
    func postNotice(title: String, content: String, target: NoticeTargetType) async -> AnyPublisher<Bool, NetworkError> {
        let request = PostNoticeRequest(title: title, content: content, target: target.rawValue)
        let result = await self.noticeService.postNotice(request: request)
        
        return Future<Bool, NetworkError> { promise in
            switch result {
            case .success(let bool):
                promise(.success(bool))
            case .failure:
                promise(.failure(NetworkError.serverError))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteNotice(noticeId: String) async -> AnyPublisher<Bool, NetworkError> {
        let request = DeleteNoticeRequest(noticeId: noticeId)
        let result = await self.noticeService.deleteNotice(request: request)
        
        return Future<Bool, NetworkError> { promise in
            switch result {
            case .success(let bool):
                promise(.success(bool))
            case .failure:
                promise(.failure(NetworkError.serverError))
            }
        }.eraseToAnyPublisher()
    }
}
