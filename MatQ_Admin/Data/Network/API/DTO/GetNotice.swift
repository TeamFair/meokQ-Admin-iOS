//
//  GetNotice.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Foundation

// MARK: - GetNoticeRequest
struct GetNoticeRequest: Encodable {
    let page: Int
    let size: String = "10"
    let target: String
}

// MARK:  GetNoticeResponse
struct GetNoticeResponse: Decodable {
    let size: Int
    let data: [GetNotice]
    let total: Int
    let page: Int
    let status: String
    let message: String
}

extension GetNoticeResponse {
    var toDomain: [Notice] {
        return self.data.map { Notice.init(getNotice: $0) }
    }
}

// MARK: GetNotice
struct GetNotice: Codable {
    let noticeId: String
    let title: String
    let content: String
    let createDate: String?
    let target: String
   
    init(noticeId: String, title: String, content: String, createDate: String?, target: String) {
        self.noticeId = noticeId
        self.title = title
        self.content = content
        self.createDate = createDate
        self.target = target
    }
}

// MARK: - PostNoticeRequest
struct PostNoticeRequest: Codable {
    let title: String
    let content: String
    let target: String
}

// MARK: PostNoticeResponse
struct PostNoticeResponse: Decodable {
    let data: [PostNoticeRequest]
    let status: String
    let message: String
}


// MARK: - DeleteNoticeRequest
struct DeleteNoticeRequest: Codable {
    let noticeId: String
}

// MARK: DeleteNoticeResponse
struct DeleteNoticeResponse: Decodable {
    let data: [String: String]?
    let errorStatus: String?
    let errMessage: String?
    let status: String?
    let message: String?
}
