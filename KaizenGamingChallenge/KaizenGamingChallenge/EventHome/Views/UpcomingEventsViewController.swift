//
//  ViewController.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import UIKit

final class UpcomingEventsViewController: UIViewController {
    
    private let presenter = UpcomingEventsPresenter()
 
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.sectionHeaderTopPadding = 0
        tv.sectionFooterHeight = 0
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor(red: 29, green: 32, blue: 37)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        setupNavigation()
        registerCells()
        setupView()
        presenter.fetchContent()
        tableView.dataSource = self
        tableView.delegate = self

//        let defaults = UserDefaults.standard
//        defaults.set(["45518084","45518082"], forKey: "fav")

    }
    
    func setupNavigation() {
        let logo = UIImage(named: "betano")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    private func registerCells() {
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension UpcomingEventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowInSection(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as? EventTableViewCell,
              let section = presenter.sections[safe: indexPath.section],
              case let .sportSection(content, _) = section else { return .init() }
        let sortedEvents = presenter.sortEventByFavorite(content.activeEvents)
        cell.setup(sortedEvents, collectionDelegate: self)
//        reloadTest()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionContent = presenter.getSectionContent(at: section),
              case let .sportSection(content, isExpanded) = sectionContent else { return nil }
        
        let view = SportNameHeaderView()
        view.setup(sportName: content.sportName, content.sportId.image, section, isExpanded)
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}

// MARK: - ViewCode
extension UpcomingEventsViewController: ViewCode {
    func buildHierarchy() {
        self.view.addSubview(tableView)
    }
    
    func buildConstratins() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

// MARK: - SportNameHeaderViewDelegate
extension UpcomingEventsViewController: SportNameHeaderViewDelegate {
    func toogleColapse(with section: Int?) {
        guard let section = section,
              case let .sportSection(content, isExpanded) = presenter.getSectionContent(at: section) else { return }
        presenter.updateSection(with: .sportSection(content: content, isExpanded: !isExpanded), at: section)
        tableView.reloadSections(IndexSet(integer: section), with: .fade)
    }
}


extension UpcomingEventsViewController: EventCollectionViewCellDelegate {
    func toogleFavorite(activeEvent: EventModel) {
        let defaults = UserDefaults.standard
        var myArray = [String]()
        
        if let savedArray = defaults.object(forKey: "fav") as? [String] {
            if activeEvent.isFavorite {
                myArray = savedArray.filter { $0 != activeEvent.eventId }
            } else {
                myArray = savedArray
                myArray.append(activeEvent.eventId)
            }
        } else {
            myArray.append(activeEvent.eventId)
        }
        defaults.set(myArray, forKey: "fav")
        tableView.reloadData()
    }
}

extension UpcomingEventsViewController: UpcomingEventsPresenterProtocol {
    func displayContent() {
        tableView.reloadData()
    }
}
