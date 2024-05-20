//
//  ViewController.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import UIKit

protocol UpcomingEventsViewProtocol: AnyObject {
    func displayContent()
    func set(loading: Bool)
    func showAlert(erroDescription: String, tryAgainAction: (() -> Void)?)
}

final class UpcomingEventsViewController: BaseViewController {
    
    var presenter: UpcomingEventsPresenterProtocol
 
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.sectionFooterHeight = 0
        tv.separatorStyle = .none
        tv.backgroundColor = .primary
        tv.accessibilityIdentifier = "upcomingEventsTableView"
        tv.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            tv.sectionHeaderTopPadding = 0
        }
        return tv
    }()
    
    init(presenter: UpcomingEventsPresenterProtocol) {
        self.presenter = presenter
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupPullToRefresh(on: tableView)
        registerCells()
        setupView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.fetchContent()
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

// MARK: - EventCollectionViewCellDelegate
extension UpcomingEventsViewController: EventCollectionViewCellDelegate {
    func toogleFavorite(activeEvent: EventModel) {
        presenter.toggleFavorite(activeEvent)
        tableView.reloadData()
    }
}

// MARK: - UpcomingEventsViewProtocol
extension UpcomingEventsViewController: UpcomingEventsViewProtocol {
    func displayContent() {
        tableView.reloadData()
    }
    
    func set(loading: Bool) {
        loading ? startLoder() : stopLoader()
    }
}

extension UpcomingEventsViewController {
    func showAlert(erroDescription: String, tryAgainAction: (() -> Void)?) {
        self.loadingView?.dismiss(animated: true, completion: { [weak self] in
            self?.setupErrorAlert(erroDescription: erroDescription, tryAgainAction: tryAgainAction)
        })
    }
    
    private func setupErrorAlert(erroDescription: String, tryAgainAction: (() -> Void)?) {
        let alert = UIAlertController(title: "Ops!", message: erroDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "Try Again", style: .default) {_ in
            tryAgainAction?()
        })
        alert.addAction(.init(title: "Cancel", style: .destructive) { _ in
            alert.dismiss(animated: true)
        })
        self.present(alert, animated: true)
    }
}

//MARK: - PullToRefreshProtocol
extension UpcomingEventsViewController: PullToRefreshProtocol {
    func pullToRefreshAction() {
        presenter.fetchContent()
    }
}
