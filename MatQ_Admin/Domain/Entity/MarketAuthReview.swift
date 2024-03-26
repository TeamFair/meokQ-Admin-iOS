//
//  MarketAuth.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/4/24.
//

import Foundation
import UIKit

struct MarketAuthRiview {
    let marketId: String
    let marketDetail: MarketDetail
    let marketAuth: MarketAuth
}

// TODO: 확인
struct MarketAuth: Equatable {
    let recordId, marketId: String
    var `operator`: Operator
    var license: License
}

struct Operator: Equatable {
    let name : String
    let birthdate: String
    let idcardImage: AwsImage
    var idcardUIImage: UIImage?
    
    init(name: String, birthdate: String, idcardImage: AwsImage, idcardUIImage: UIImage? = nil) {
        self.name = name
        self.birthdate = birthdate
        self.idcardImage = idcardImage
        self.idcardUIImage = idcardUIImage
    }
    
    init(awsOperator: AwsOperator) {
        self.name = awsOperator.name
        self.birthdate = awsOperator.birthdate
        self.idcardImage = awsOperator.idcardImage
        self.idcardUIImage = nil
    }
}

struct License: Equatable {
    let licenseId: String
    let licenseImage: AwsImage
    let ownerName, marketName, address, postalCode: String
    let salesType: String? // TODO: 배포 시 옵셔널 해제
    var image: UIImage?
    
    init(licenseId: String, licenseImage: AwsImage, ownerName: String, marketName: String, address: String, postalCode: String, salesType: String?, image: UIImage? = nil) {
        self.licenseId = licenseId
        self.licenseImage = licenseImage
        self.ownerName = ownerName
        self.marketName = marketName
        self.address = address
        self.postalCode = postalCode
        self.salesType = salesType
        self.image = image
    }
    
    init(awsLicense: AwsLicense) {
        self.licenseId = awsLicense.licenseId
        self.licenseImage = awsLicense.licenseImage
        self.ownerName = awsLicense.ownerName
        self.marketName = awsLicense.marketName
        self.address = awsLicense.address
        self.postalCode = awsLicense.postalCode
        self.salesType = awsLicense.salesType
        self.image = nil
    }
}
