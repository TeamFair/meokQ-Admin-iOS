//
//  Challenge.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import UIKit

struct Challenge: Hashable {
    let challengeId: String
    let userNickName: String
    let challengeTitle: String
    let receiptImageId: String?
    let status: String
    let createdAt: String
    var image: UIImage?
}
