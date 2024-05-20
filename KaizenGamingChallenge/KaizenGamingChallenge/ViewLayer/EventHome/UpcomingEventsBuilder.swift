//
//  UpcomingEventsBuilder.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 19/05/24.
//

import Foundation

struct UpcomingEventsBuilder {
    func build() -> UpcomingEventsViewController {
        let service = UpComingEventsService()
        let presenter = UpcomingEventsPresenter(service: service)
        let viewController = UpcomingEventsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
    
    func buildWithNavigationController() -> BaseNavigationController {
        BaseNavigationController(rootViewController: build())
    }
}
