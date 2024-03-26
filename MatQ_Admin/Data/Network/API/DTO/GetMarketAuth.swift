//
//  GetMarketAuth.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 1/4/24.
//
import Foundation

// MARK: - GetMarketAuthRequest
struct GetMarketAuthRequest: Encodable {
    let page: String = "0"
    let size: String = "10"
    let marketId: String
}

// MARK: GetMarketAuthResponse
struct GetMarketAuthResponse: Decodable {
    let size: Int
    let data: [GetMarketAuth]
    let total: Int
    let page: Int
    let status: String
    let message: String
}

extension GetMarketAuthResponse {
    var toDomain: [MarketAuth] {
        return self.data.map { MarketAuth(recordId: $0.recordId, marketId: $0.marketId, operator: Operator(awsOperator: $0.operator), license: License(awsLicense: $0.license)) }
    }
}

// MARK: - PutReviewMarketAuthRequest
struct PutReviewMarketAuthRequest: Encodable {
    var recordId: String
    var comment: String?
    var reviewResult: String
}

enum ReviewResult: Encodable {
    case approve
    case reject
    
    var statusText: String {
        switch self {
        case .approve:
            "APPROVED"
        case .reject:
            "REJECTED"
        }
    }
}

// MARK: PutReviewMarketAuthResponse
struct PutReviewMarketAuthResponse: Decodable {
    let data: [String: String]
    let status, message: String
}


// MARK: - GetMarketAuth
struct GetMarketAuth: Codable {
    let recordId, marketId: String
    let reviewResult : String?
    let comment: String?
    let `operator`: AwsOperator
    let license: AwsLicense
    
    init(recordId: String, marketId: String, reviewResult: String, comment: String?, operator: AwsOperator, license: AwsLicense) {
        self.recordId = recordId
        self.marketId = marketId
        self.reviewResult = reviewResult
        self.comment = comment
        self.operator = `operator`
        self.license = license
    }
}

// MARK: - AwsOperator

struct AwsOperator: Codable, Equatable {
    let name : String
    let birthdate: String
    let idcardImage: AwsImage
}

// MARK: - AwsImage
struct AwsImage: Codable, Equatable {
    let imageId, location: String
}

// MARK: - AwsLicense
struct AwsLicense: Codable, Equatable {
    let licenseId: String
    let licenseImage: AwsImage
    let ownerName, marketName, address, postalCode: String, salesType: String? // TODO: 배포 시 옵셔널 해제
}
