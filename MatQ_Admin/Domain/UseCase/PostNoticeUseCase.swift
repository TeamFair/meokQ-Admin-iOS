//
//  PostNoticeUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Combine

protocol PostNoticeUseCaseInterface {
    func postNotice(title: String, content: String, target: NoticeTargetType) async -> AnyPublisher<Bool, NetworkError>
}

final class PostNoticeUseCase: PostNoticeUseCaseInterface {
    
    let noticeRepository: NoticeRepositoryInterface
    
    init(noticeRepository: NoticeRepositoryInterface) {
        self.noticeRepository = noticeRepository
    }
    
    func postNotice(title: String, content: String, target: NoticeTargetType) async -> AnyPublisher<Bool, NetworkError> {
        return await self.noticeRepository.postNotice(title: title, content: content, target: target)
    }
}
