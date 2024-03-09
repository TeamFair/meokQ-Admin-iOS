//
//  Notice.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Foundation

struct Notice {
    let noticeId: String
    let title: String
    let content: String
    let createDate: String?
    let target: String
    
    init(getNotice: GetNotice) {
        self.noticeId = getNotice.noticeId
        self.title = getNotice.title
        self.content = getNotice.content
        self.createDate = getNotice.createDate
        self.target = getNotice.target
    }
}
