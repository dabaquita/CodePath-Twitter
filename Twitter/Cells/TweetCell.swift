//
//  TweetCell.swift
//  Twitter
//
//  Created by Denielle Abaquita on 9/20/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    static let identifier = "TweetCell"
    let profileImageView = UIImageView()
    var profileNameLabel = UILabel()
    var tweetLabel = UILabel()
    
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureProfileImageView()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Views
    private func configureProfileImageView() {
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        contentView.addSubview(profileImageView)
        
        // Constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            profileImageView.heightAnchor.constraint(equalToConstant: contentView.bounds.height),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
    }
    
    private func configureStackView() {
        // Subviews setup
        configureProfileNameLabel()
        configureTweetLabel()
        
        // Stackview setup
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(profileNameLabel)
        stackView.addArrangedSubview(tweetLabel)
        
        // Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func configureProfileNameLabel() {
        profileNameLabel.numberOfLines = 1
        profileNameLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    private func configureTweetLabel() {
        tweetLabel.numberOfLines = 0
        tweetLabel.font = .systemFont(ofSize: 15)
    }
}
