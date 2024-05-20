//
//  UpcomingEventsPresentTest.swift
//  KaizenGamingChallengeTests
//
//  Created by Luan Cabral on 20/05/24.
//

import Foundation
import XCTest
@testable import KaizenGamingChallenge

final class UpcomingEventsPresentTest: XCTestCase {
    // MARK: - Properties
    private var presenter: UpcomingEventsPresenter?
    private var onDidDelegateHit: ((DelegateHit) -> Void)?
    
    enum DelegateHit {
        case displayContent
        case showAlert(String)
        case tryAgain
    }
    
    override func tearDown() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "favoriteEvents")
    }
    
    func makePresenter(service: UpcomingEventsServiceProtocol = UpComingEventsServiceDummy(),
                       _ model: AllEventsModel? = nil) {
        presenter = UpcomingEventsPresenter(service: service, model)
        presenter?.view = self
    }
    
    func testFetchContentSuccess() throws{
        let expectation = expectation(description: "Should hit displayContent delegate")
        let mockedModel = try XCTUnwrap(JSONModelFactory.makeModel(AllEventsModel.self,
                                                                   fromJSON: "UpComingEvents"))
        let serviceStub = UpComingEventsServiceStub()
        serviceStub.fetchUpcomingEventsResult = .success(mockedModel)
        makePresenter(service: serviceStub)
        
        onDidDelegateHit = { hit in
            switch hit {
            case .displayContent:
                expectation.fulfill()
            default:
                XCTFail("Hit wrong delegate")
            }
        }
        
        presenter?.fetchContent()
        waitForExpectations(timeout: 10)
    }
    
    func testFetchContentFiulre() throws{
        let expectation = expectation(description: "Should hit showAlert delegate")

        let serviceStub = UpComingEventsServiceStub()
        serviceStub.fetchUpcomingEventsResult = .failure(.network)
        makePresenter(service: serviceStub)
        
        onDidDelegateHit = { hit in
            switch hit {
            case .showAlert(let erroDescription):
                XCTAssertEqual(erroDescription, ServiceError.network.message)
                expectation.fulfill()
            default:
                XCTFail("Hit wrong delegate")
            }
        }
        
        presenter?.fetchContent()
        waitForExpectations(timeout: 10)
    }
    
    func testSortEventByFavorite() {
        
        let mockedArray: [EventModel] = [
            .init(eventName: "Test event", eventId: "123", match: "Test match", sportId: .soccer, startTime: 12344),
            .init(eventName: "Test event", eventId: "456", match: "Test match", sportId: .soccer, startTime: 12344)
        ]
        
        let expectedArray: [EventModel] = [
            .init(eventName: "Test event", eventId: "456", match: "Test match", sportId: .soccer, startTime: 12344),
            .init(eventName: "Test event", eventId: "123", match: "Test match", sportId: .soccer, startTime: 12344)
        ]
        
        let userDefaultManager = UserDefaultManager(defaults: .standard, keyName: "favoriteEvents")
        userDefaultManager.update(with: "456")
        makePresenter()
        
        XCTAssertEqual(presenter?.sortEventByFavorite(mockedArray), expectedArray)
    }
    
    
    // MARK: - TableView Methods
}

extension UpcomingEventsPresentTest: UpcomingEventsViewProtocol {
    func displayContent() {
        onDidDelegateHit?(.displayContent)
    }
    
    func set(loading: Bool) {
        return
    }
    
    func showAlert(erroDescription: String, tryAgainAction: (() -> Void)?) {
        onDidDelegateHit?(.showAlert(erroDescription))
    }
}
