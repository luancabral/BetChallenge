//
//  SportNameHeaderView.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import UIKit

protocol SportNameHeaderViewDelegate: AnyObject {
    func toogleColapse(with section: Int?)
}

final class SportNameHeaderView: UIView {
    var section: Int?
    var isExpanded = false {
        didSet {
            stateImageView.image = isExpanded ? UIImage(systemName: "chevron.up"): UIImage(systemName: "chevron.down")
        }
    }
    
    // MARK: - UI Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sportImageView: UIImageView = {
        let sportImageView = UIImageView()
        sportImageView.image = UIImage(systemName: "soccerball")
        sportImageView.contentMode = .scaleAspectFill
        sportImageView.translatesAutoresizingMaskIntoConstraints = false
        return sportImageView
    }()
    
    private let stateImageView: UIImageView = {
        let stateImageView = UIImageView()
        stateImageView.translatesAutoresizingMaskIntoConstraints = false
        stateImageView.tintColor = .white
        return stateImageView
    }()
    
    // MARK: - Properties
    weak var delegate: SportNameHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(sportName: String, _ image: UIImage?, _ section: Int, _ isExpanded: Bool) {
        titleLabel.text = sportName
        sportImageView.image = image
        self.section = section
        self.isExpanded = isExpanded
        self.backgroundColor = UIColor(red: 36, green: 43, blue: 53)
        setupGesture()
        setupView()
        
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap() {
        guard let section = self.section else { return }
        delegate?.toogleColapse(with: section)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCode
extension SportNameHeaderView: ViewCode {
    func buildHierarchy() {
        addSubview(sportImageView)
        addSubview(titleLabel)
        addSubview(stateImageView)
    }
    
    func buildConstratins() {
        NSLayoutConstraint.activate([
            sportImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            sportImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            
            sportImageView.widthAnchor.constraint(equalToConstant: 16),
            sportImageView.heightAnchor.constraint(equalToConstant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: sportImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: stateImageView.leadingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stateImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stateImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stateImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
