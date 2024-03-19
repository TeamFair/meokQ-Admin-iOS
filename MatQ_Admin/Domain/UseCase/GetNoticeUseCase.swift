//
//  GetNoticeUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Combine

protocol GetNoticeUseCaseInterface {
    func getNoticeList(target: NoticeTargetType, page: Int) async -> AnyPublisher<[Notice], NetworkError>
}

final class GetNoticeUseCase: GetNoticeUseCaseInterface {
    
    let noticeRepository: NoticeRepositoryInterface
    
    init(noticeRepository: NoticeRepositoryInterface) {
        self.noticeRepository = noticeRepository
    }
    
    func getNoticeList(target: NoticeTargetType, page: Int = 0) async -> AnyPublisher<[Notice], NetworkError> {
        return await self.noticeRepository.getNotice(target: target, page: page)
    }
}
