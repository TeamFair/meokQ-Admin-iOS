//
//  PutQuestUseCaseTests.swift
//  AdminAppTest
//
//  Created by Lee Jinhee on 10/23/24.
//

import XCTest
import Combine

// MARK: 퀘스트 수정 유스케이스 테스트
/*
final class PutQuestUseCaseTests: XCTestCase {
    var useCase: PutQuestUseCase!
    var mockQuestRepository: MockQuestRepository!
    var mockImageRepository: MockImageRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockQuestRepository = MockQuestRepository()
        mockImageRepository = MockImageRepository()
        useCase = PutQuestUseCase(questRepository: mockQuestRepository, imageRepository: mockImageRepository)
        cancellables = []
    }
    
    override func tearDown() {
        useCase = nil
        mockQuestRepository = nil
        mockImageRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_execute_withNewImage_success() {
        // Given: 이미지가 새로 업데이트되고, 퀘스트 PUT 성공
        mockImageRepository.result = .success("IIM00000000")
        mockQuestRepository.result = .success(())
        
        let expectation = XCTestExpectation(description: "Successfully uploaded image and put quest")
        
        // When: 유스케이스 실행
        useCase.execute(questId: "quest123",
                        writer: "writer1",
                        image: UIImage(),
                        imageId: nil,
                        missionTitle: "New Mission",
                        rewardList: [Reward(content: "FUN", quantity: 30)],
                        score: 100,
                        expireDate: "2024-12-31",
                        imageUpdated: true)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got failure: \(error)")
            }
        }, receiveValue: { })
        .store(in: &cancellables)
        
        // Then: 비동기 완료 기다림
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_execute_withExistingImage_success() {
        // Given: 기존 이미지 사용, 퀘스트 PUT 성공
        mockQuestRepository.result = .success(())
        
        let expectation = XCTestExpectation(description: "Successfully put quest with existing image")
        
        // When
        useCase.execute(questId: "quest123",
                        writer: "writer1",
                        image: nil,
                        imageId: "existing_image_id",
                        missionTitle: "Existing Mission",
                        rewardList: [Reward(content: "FUN", quantity: 30)],
                        score: 100,
                        expireDate: "2024-12-31",
                        imageUpdated: false)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got failure: \(error)")
            }
        }, receiveValue: { })
        .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_execute_withInvalidImage_failure() {
        // Given: 이미지 ID && 이미지가 없어서 실패하는 시나리오
        let expectation = XCTestExpectation(description: "Fail to put quest due to invalid image")
        
        // When
        useCase.execute(questId: "quest123",
                        writer: "writer1",
                        image: nil,
                        imageId: nil,
                        missionTitle: "Mission",
                        rewardList: [Reward(content: "FUN", quantity: 30)],
                        score: 100,
                        expireDate: "2024-12-31",
                        imageUpdated: false)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidImageData)
                expectation.fulfill()
            }
        }, receiveValue: { })
        .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_execute_emptyRewardList_failure() {
        // Given: 보상 리스트가 비어있어서 실패하는 시나리오
        let expectation = XCTestExpectation(description: "Fail to put quest due to empty reward list")
        
        // When
        useCase.execute(questId: "quest123",
                        writer: "writer1",
                        image: nil,
                        imageId: "existing_image_id",
                        missionTitle: "Mission",
                        rewardList: [],
                        score: 100,
                        expireDate: "2024-12-31",
                        imageUpdated: false)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.unknownError)
                expectation.fulfill()
            }
        }, receiveValue: { })
        .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
}
*/
