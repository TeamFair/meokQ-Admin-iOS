//
//  Banner.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import Combine
import UIKit

struct Banner: Equatable {
    let id: Int
    var imageId: String
    var image: UIImage?
    var title: String
    var description: String
    var activeYn: Bool

    init(id: Int, imageId: String, image: UIImage?, title: String, description: String, activeYn: String) {
        self.id = id
        self.imageId = imageId
        self.image = image
        self.title = title
        self.description = description
        self.activeYn = activeYn == "Y"
    }
    
    init() {
        self.id = -1
        self.imageId = ""
        self.image = .nullimage
        self.title = ""
        self.description = "illsang://tab/"
        self.activeYn = false
    }
    
    static let mockActiveData = Banner(id: 1, imageId: "imageId", image: UIImage.testimage, title: "타이틀1", description: "illsang://tab/quest", activeYn: "Y")
    static let mockInactiveData = Banner(id: 2, imageId: "imageId", image: UIImage.testimage, title: "타이틀2", description: "illsang://tab/ranking", activeYn: "N")
    static let mockDataList = [mockActiveData, mockInactiveData]
}
