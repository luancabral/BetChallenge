//
//  KaizenGamingChallengeUITests.swift
//  KaizenGamingChallengeUITests
//
//  Created by Luan Cabral on 17/05/24.
//

import XCTest

final class KaizenGamingChallengeUITests: XCTestCase {
    let app = XCUIApplication()

    func testCloseCells() {
        app.launch()
        
        let soccerHeader = app.tables["upcomingEventsTableView"].staticTexts["SOCCER"]
        soccerHeader.tap()
        app.swipeUp(velocity: 4500)
        let dartHeader = app.tables["upcomingEventsTableView"].staticTexts["DARTS"]
        dartHeader.tap()
        
        app.swipeDown(velocity: 4500)
        soccerHeader.tap()
    }
    
    func testScrollCollection() {
        let collectionView = app.collectionViews["eventCollectionView"].firstMatch
        collectionView.swipeLeft(velocity: 4500)
        
        app.swipeUp()
    }
}
