//
//  EventTableViewCell.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import UIKit

final class EventTableViewCell: UITableViewCell {
    
    static let identifier = "EventTableViewCell"
    
    private var activeEvents = [EventModel]()
    
    weak var collectionDelegate: EventCollectionViewCellDelegate?
        
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 135, height: 135)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor(red: 29, green: 32, blue: 37)
        setupView()
        collectionView.dataSource = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ events: [EventModel], collectionDelegate: EventCollectionViewCellDelegate) {
        self.activeEvents = events
        self.collectionDelegate = collectionDelegate
        collectionView.reloadData()
    }
}

extension EventTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activeEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.identifier, for: indexPath) as? EventCollectionViewCell,
              let event = self.activeEvents[safe: indexPath.row] else { return .init() }
        cell.setup(activeEvent: event)
        cell.delegate = self.collectionDelegate
        return cell
    }
}

extension EventTableViewCell: ViewCode{
    func buildHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    func buildConstratins() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}