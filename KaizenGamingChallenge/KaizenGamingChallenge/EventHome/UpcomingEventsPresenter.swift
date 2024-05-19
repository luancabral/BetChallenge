//
//  UpcomingEventsPresenter.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import Foundation

protocol UpcomingEventsPresenterProtocol: AnyObject {
    func displayContent()
}

final class UpcomingEventsPresenter {
    enum Sections {
        case sportSection(content: EventDetailsModel, isExpanded: Bool)
    }
    
    weak var delegate: UpcomingEventsPresenterProtocol?
    
    var model: AllEventsModel?
    var sections: [Sections] = []
    
    func fetchContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            guard let mock = EventDetailsModel.makeMock() else { return }
            self.model = mock
            self.setupSections()
            self.delegate?.displayContent()
        })
    }
    
    func setupSections() {
        model?.forEach({ activeEvent in
            sections.append(.sportSection(content: activeEvent, isExpanded: true))
        })
    }
    
    func sortEventByFavorite(_ activeEvents: [EventModel]) -> [EventModel] {
        let startTimeSort = activeEvents.sorted{ $0.startTime < $1.startTime}
        return startTimeSort.sorted{ $0.isFavorite && !$1.isFavorite }
    }
}

// MARK: - TableView Methods
extension UpcomingEventsPresenter {
    func numberOfRowInSection(in section: Int) -> Int {
        let currentSection = getSectionContent(at: section)
        if case let .sportSection(_, isExpanded) = currentSection {
            return isExpanded ? 1 : 0
        }
        
        return 0
    }
    
    func getSectionContent(at position: Int) -> Sections? {
        return sections[safe: position]
    }
    
    func updateSection(with newData: Sections, at position: Int) {
        guard sections.count > position else { return }
        sections[position] = newData
    }
}

// MARK: - Mock
extension UpcomingEventsPresenter {
//    func makeMock() -> AllEventsModel? {
//        return try? JSONModelFactory.makeModel(AllEventsModel.self, fromJSON: "mock")
//    }
}
