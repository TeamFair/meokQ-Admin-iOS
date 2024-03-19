//
//  DeleteNoticeUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/10/24.
//

import Foundation

import Combine

protocol DeleteNoticeUseCaseInterface {
    func deleteNotice(noticeId: String) async -> AnyPublisher<Bool, NetworkError>
}

final class DeleteNoticeUseCase: DeleteNoticeUseCaseInterface {
    
    let noticeRepository: NoticeRepositoryInterface
    
    init(noticeRepository: NoticeRepositoryInterface) {
        self.noticeRepository = noticeRepository
    }
    
    func deleteNotice(noticeId: String) async -> AnyPublisher<Bool, NetworkError> {
        return await self.noticeRepository.deleteNotice(noticeId: noticeId)
    }
}
