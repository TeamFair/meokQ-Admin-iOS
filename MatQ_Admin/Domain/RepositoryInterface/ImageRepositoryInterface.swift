//
//  ImageRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import Combine
import UIKit

protocol ImageRepositoryInterface {
    func getImage(request: GetImageRequest) -> AnyPublisher<UIImage, NetworkError>
    func postImage(image: UIImage, type: ImageType) -> AnyPublisher<String, NetworkError>
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError>
    func getImageIds(request: GetImageIdsRequest) -> AnyPublisher<[String], NetworkError>
}
