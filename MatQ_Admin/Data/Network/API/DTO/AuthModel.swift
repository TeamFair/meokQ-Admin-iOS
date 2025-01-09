//
//  AuthModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 12/27/24.
//

import Foundation

struct PostAuthRequest: Encodable {
    let userType: String = "ADMIN"
    let accessToken: String = "accessToken"
    let refreshToken: String = "refreshToken"
    let email: String = "admin"
    let channel: String = "KAKAO"
}

struct PostAuthResponse: Decodable {
    let authorization: String?
}
