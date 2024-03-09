//
//  NoticeService.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Alamofire
import Combine
import Foundation

protocol NoticeServiceInterface {
    func getNoticeList(request: GetNoticeRequest) async -> Result<[Notice], NetworkError>
    func postNotice(request: PostNoticeRequest) async -> Result<Bool, NetworkError>
    func deleteNotice(request: DeleteNoticeRequest) async -> Result<Bool, NetworkError>
}

struct NoticeService: NoticeServiceInterface {
    func getNoticeList(request: GetNoticeRequest) async -> Result<[Notice], NetworkError> {
        let taskRequest = AF.request(NoticeTarget.getNotice(request))
            .validate(statusCode: 200..<300)
            .serializingDecodable(GetNoticeResponse.self)
        
        switch await taskRequest.result {
        case .success(let response):
            return .success(response.toDomain)
        case .failure:
            return .failure(NetworkError.serverError)
        }
    }
    
    func postNotice(request: PostNoticeRequest) async -> Result<Bool, NetworkError> {
        let request = AF.request(NoticeTarget.postNotice(request))
            .validate(statusCode: 200..<300)
            .serializingDecodable(PostNoticeResponse.self)

        switch await request.result {
        case .success:
            return .success(true)
        case .failure:
            return .failure(NetworkError.serverError)
        }
    }
    
    func deleteNotice(request: DeleteNoticeRequest) async -> Result<Bool, NetworkError> {
        let request = AF.request(NoticeTarget.deleteNotice(request))
            .validate(statusCode: 200..<300)
            .serializingDecodable(DeleteImageResponse.self)
        
        switch await request.result {
        case .success:
            return .success(true)
        case .failure:
            return .failure(NetworkError.serverError)
        }
    }
}
