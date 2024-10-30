//
//  DeleteChallengeUseCaseTests.swift
//  MatQ_Admin_Tests
//
//  Created by Lee Jinhee on 10/30/24.
//

import XCTest
import Combine

final class DeleteChallengeUseCaseTests: XCTestCase {
    var useCase: DeleteChallengeUseCase!
    var mockChallengeRepository: MockChallengeRepository!
    var mockImageRepository: MockImageRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        mockChallengeRepository = MockChallengeRepository()
        mockImageRepository = MockImageRepository()
        useCase = DeleteChallengeUseCase(challengeRepository: mockChallengeRepository, imageRepository: mockImageRepository)
        cancellables = []
        
        // 초기화
        mockChallengeRepository.isDeleteChallengeCalled = false
        mockImageRepository.isDeleteImageCalled = false
    }
 
    override func tearDownWithError() throws {
        useCase = nil
        mockChallengeRepository = nil
        mockImageRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_이미지아이디가_있고_이미지삭제성공시_챌린지삭제도성공() {
        // Given: 이미지 삭제를 성공하고, 챌린지 삭제 성공
        mockImageRepository.result = .success("SUCCESS") // 서버응답의 status값을 반환함
        mockChallengeRepository.result = .success(())
        
        let expectation = XCTestExpectation(description: "이미지 삭제 및 챌린지 삭제 성공")
        
        // When: 유스케이스 실행
        useCase.execute(challengeId: "ICH000001", imageId: "IIM000001")
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
    
    func test_이미지아이디가_있고_이미지삭제실패시_챌린지삭제안됨() {
        // Given: 이미지 삭제 실패
        mockImageRepository.result = .failure(.error((400, "", ""))) // 서버응답의 status값을 반환함
        
        let expectation = XCTestExpectation(description: "이미지 삭제 실패 및 챌린지 삭제 안함")
        
        // When: 유스케이스 실행
        useCase.execute(challengeId: "ICH000001", imageId: "IIM000001")
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTFail("Expected failure but got finish")
            case .failure:
                expectation.fulfill()
            }
        }, receiveValue: { })
        .store(in: &cancellables)
        
        // Then: 비동기 완료 기다림
        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(mockChallengeRepository.isDeleteChallengeCalled, "챌린지 삭제는 호출되면 안됨")
    }
    
    func test_이미지아이디가_있고_406에러시_챌린지삭제성공() {
        // Given: 이미지 삭제 406 실패, 챌린지 삭제 성공
        mockImageRepository.result = .failure(.error((406, "NOT_FOUND_DATA", ""))) // 서버응답의 status값을 반환함
        mockChallengeRepository.result = .success(())
        
        let expectation = XCTestExpectation(description: "이미지 삭제 실패 및 챌린지 삭제 성공")
        
        // When: 유스케이스 실행
        useCase.execute(challengeId: "ICH000001", imageId: "IIM000001")
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
        XCTAssertTrue(mockChallengeRepository.isDeleteChallengeCalled, "챌린지 삭제는 호출되야함")
    }  

    func test_이미지아이디가_있으나_길이0일때_챌린지삭제성공() {
        // Given: 이미지 삭제 안함, 챌린지 삭제 성공
        mockChallengeRepository.result = .success(())
        let invalidImageId = ""
        
        let expectation = XCTestExpectation(description: "이미지 삭제 안함 및 챌린지 삭제 성공")
        
        // When: 유스케이스 실행
        useCase.execute(challengeId: "ICH000001", imageId: invalidImageId)
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
        XCTAssertTrue(mockChallengeRepository.isDeleteChallengeCalled, "챌린지 삭제는 호출되야함")
        XCTAssertFalse(mockImageRepository.isDeleteImageCalled, "이미지 아이디가 유효하지 않으므로 이미지 삭제는 호출되지 않아야 함")
    }
    
    func test_이미지아이디없을때_이미지삭제없이_챌린지삭제성공() {
        // Given: 챌린지 삭제 성공
        mockChallengeRepository.result = .success(())
        
        let expectation = XCTestExpectation(description: "이미지 삭제 안함 및 챌린지 삭제 성공")
        
        // When: 유스케이스 실행
        useCase.execute(challengeId: "ICH000001", imageId: nil)
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
        XCTAssertTrue(mockChallengeRepository.isDeleteChallengeCalled, "챌린지 삭제는 호출되야함")
        XCTAssertFalse(mockImageRepository.isDeleteImageCalled, "이미지 삭제는 호출되면 안됨")
    }
    
    func test_이미지아이디없을때_이미지삭제없이_챌린지삭제실패() {
        // Given: 챌린지 삭제 실패
        mockChallengeRepository.result = .failure(.unknownError)
        
        let expectation = XCTestExpectation(description: "이미지 아이디가 유효하지 않으므로 이미지 삭제 안함 및 챌린지 삭제 실패")
        
        // When: 유스케이스 실행
        useCase.execute(challengeId: "ICH000001", imageId: nil)
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
        
        // Then: 비동기 완료 기다림
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockChallengeRepository.isDeleteChallengeCalled, "챌린지 삭제는 호출되야함")
        XCTAssertFalse(mockImageRepository.isDeleteImageCalled, "이미지 아이디가 유효하지 않으므로 이미지 삭제는 호출되면 안됨")
    }
}
