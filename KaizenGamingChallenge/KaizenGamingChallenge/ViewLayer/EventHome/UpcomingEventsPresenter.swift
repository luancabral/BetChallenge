//
//  UpcomingEventsPresenter.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import Foundation
import Alamofire

enum Sections {
    case sportSection(content: EventDetailsModel, isExpanded: Bool)
}

protocol UpcomingEventsPresenterProtocol: AnyObject {
    var sections: [Sections] { get }
    
    func fetchContent()
    func numberOfRowInSection(in section: Int) -> Int
    func sortEventByFavorite(_ activeEvents: [EventModel]) -> [EventModel]
    func getSectionContent(at position: Int) -> Sections?
    func updateSection(with newData: Sections, at position: Int)
    func toggleFavorite(_ activeEvent: EventModel)

}

final class UpcomingEventsPresenter: UpcomingEventsPresenterProtocol {
    weak var view: UpcomingEventsViewProtocol?
    
    private(set) var model: AllEventsModel?
    private(set) var sections: [Sections] = []
    private var service: UpcomingEventsServiceProtocol
    
    init(service: UpcomingEventsServiceProtocol, _ model: AllEventsModel? = nil) {
        self.service = service
        self.model = model
    }
    
    func fetchContent() {
        view?.set(loading: true)
        service.fetchUpcomingEvents { [weak self] result in
            guard let self = self else { return }
            self.view?.set(loading: false)
            switch result {
            case .success(let content):
                self.model = content
                self.setupSections()
                self.view?.displayContent()
            case .failure(let error):
                self.view?.showAlert(erroDescription: error.message, tryAgainAction: fetchContent)
            }
        }
    }
    
    private func setupSections() {
        sections = []
        model?.forEach({ activeEvent in
            sections.append(.sportSection(content: activeEvent, isExpanded: true))
        })
    }
    
    func sortEventByFavorite(_ activeEvents: [EventModel]) -> [EventModel] {
        let startTimeSort = activeEvents.sorted { $0.startTime < $1.startTime}
        return startTimeSort.sorted { $0.isFavorite && !$1.isFavorite }
    }
    
    func toggleFavorite(_ activeEvent: EventModel) {
        let defaults = UserDefaultManager(keyName: "favoriteEvents")
        if activeEvent.isFavorite {
            defaults.remove(an: activeEvent.eventId)
        } else {
            defaults.update(with: activeEvent.eventId)
        }
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
