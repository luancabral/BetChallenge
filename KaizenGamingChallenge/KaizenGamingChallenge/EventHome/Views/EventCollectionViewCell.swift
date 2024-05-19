//
//  EventCollectionViewCell.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import UIKit

protocol EventCollectionViewCellDelegate: AnyObject {
    func toogleFavorite(activeEvent: EventModel)
}

final class EventCollectionViewCell: UICollectionViewCell {
    static let identifier = "EventCollectionViewCell"
    var timerClass: TimerManager?
    var activeEvent: EventModel?
    
    weak var delegate: EventCollectionViewCellDelegate?
    
    private let countDown: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "HH:mm:ss"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteImageView: UIImageView = {
        let favoriteImageView = UIImageView()
        favoriteImageView.image = UIImage(systemName: "star")
        favoriteImageView.tintColor = .yellow
        favoriteImageView.isUserInteractionEnabled = true
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        return favoriteImageView
    }()
    
    private let firstOpponent: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondOpponent: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func prepareForReuse() {
        countDown.text = "HH:mm:ss"
    }
    
    func setup(activeEvent: EventModel) {
        self.activeEvent = activeEvent
        setupTimer(startTime: activeEvent.startTime)
        setupFavoriteImageView(activeEvent.isFavorite)
        setupOpponentLabel(with: activeEvent.match)

        self.backgroundColor = UIColor(red: 29, green: 32, blue: 37)
        setupView()
    }
    
    private func setupFavoriteImageView(_ isFavorite: Bool) {
        favoriteImageView.image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        favoriteImageView.tintColor = isFavorite ? .yellow : .gray
        setupFavoriteTap()
    }
    
    private func setupOpponentLabel(with match: String) {
        let match = match.components(separatedBy: "-")
        if let opponent1 = match.first, let opponent2 = match.last {
            firstOpponent.text = opponent1
            secondOpponent.text = opponent2
        }
    }
    
    private func setupTimer(startTime: Int) {
        self.timerClass?.timerInvlidate()
        self.timerClass = TimerManager(targetDate: startTime)
        timerClass?.startCountDown(completion: { [weak self] remaningTime in
            guard let self = self else { return }
            self.countDown.text = remaningTime
        })
    }
    
    private func setupFavoriteTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        favoriteImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func handleTap() {
        guard let activeEvent = activeEvent else { return }
        delegate?.toogleFavorite(activeEvent: activeEvent)
    }
}

extension EventCollectionViewCell: ViewCode {
    func buildHierarchy() {
        contentView.addSubview(countDown)
        contentView.addSubview(favoriteImageView)
        contentView.addSubview(firstOpponent)
        contentView.addSubview(secondOpponent)
    }
    
    func buildConstratins() {
        NSLayoutConstraint.activate([
            countDown.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            countDown.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            favoriteImageView.topAnchor.constraint(equalTo: countDown.bottomAnchor, constant: 8),
            favoriteImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 18),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 18),
            
            firstOpponent.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor, constant: 8),
            firstOpponent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            firstOpponent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            secondOpponent.topAnchor.constraint(equalTo: firstOpponent.bottomAnchor, constant: 8),
            secondOpponent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            secondOpponent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            secondOpponent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
}
