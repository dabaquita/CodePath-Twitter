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
    
    // Subview properties
    let profileImageView = UIImageView()
    var profileNameLabel = UILabel()
    var tweetLabel = UILabel()
    
    private let stackView = UIStackView()
    
    private let buttonStackView = UIStackView()
    private let replyButton = UIButton()
    private let retweetButton = UIButton()
    private let favoriteButton = UIButton()
    
    // Usage properties
    var isFavorited: Bool = false
    var isRetweeted: Bool = false
    var tweetId: Int = -1

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
        configureButtonStackView()
        
        // Stackview setup
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.spacing = 7
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(profileNameLabel)
        stackView.addArrangedSubview(tweetLabel)
        stackView.addArrangedSubview(buttonStackView)
        
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
        profileNameLabel.font = .boldSystemFont(ofSize: 14)
    }
    
    private func configureTweetLabel() {
        tweetLabel.numberOfLines = 0
        tweetLabel.font = .systemFont(ofSize: 12)
    }
    
    private func configureButtonStackView() {
        // Subviews setup
        configureReplyButton()
        configureRetweetButton()
        configureFavoriteButton()
        
        // Stackview setup
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalSpacing
        buttonStackView.alignment = .center
        
        buttonStackView.addArrangedSubview(replyButton)
        buttonStackView.addArrangedSubview(retweetButton)
        buttonStackView.addArrangedSubview(favoriteButton)
    }
    
    private func configureReplyButton() {
        replyButton.setBackgroundImage(UIImage(named: "reply-icon"), for: .normal)
        replyButton.addTarget(
            self,
            action: #selector(didTapReplyButton),
            for: .touchUpInside
        )
    }
    
    private func configureRetweetButton() {
        retweetButton.isSelected = isRetweeted
        retweetButton.setBackgroundImage(UIImage(named: "retweet-icon"), for: .normal)
        retweetButton.setBackgroundImage(UIImage(named: "retweet-icon-green"), for: .selected)
        retweetButton.addTarget(
            self,
            action: #selector(didTapRetweetButton),
            for: .touchUpInside
        )
    }
    
    private func configureFavoriteButton() {
        favoriteButton.isSelected = isFavorited
        favoriteButton.setBackgroundImage(UIImage(named: "favor-icon"), for: .normal)
        favoriteButton.setBackgroundImage(UIImage(named: "favor-icon-red"), for: .selected)
        favoriteButton.addTarget(
            self,
            action: #selector(didTapFavoriteButton),
            for: .touchUpInside
        )
    }
    
    // MARK: Tap Handlers
    @objc func didTapReplyButton(_ sender: Any) {
        print("Tapped Reply")
    }
    
    @objc func didTapRetweetButton(_ sender: Any) {
        let toBeRetweeted = !isRetweeted
        
        if toBeRetweeted {
            TwitterAPICaller.client?.retweetTweet(
                tweetId: tweetId,
                success: { [weak self] in
                    guard let self = self else { return }
                    self.retweetButton.isSelected.toggle()
                    self.isRetweeted.toggle()
                },
                failure: { error in
                    print("Could not retweet tweet due to \(error)")
                }
            )
        } else {
            // Implement unretweet
        }
    }
    
    @objc func didTapFavoriteButton(_ sender: Any) {
        let toBeFavorited = !isFavorited
        
        if toBeFavorited {
            TwitterAPICaller.client?.favoriteTweet(
                tweetId: tweetId,
                success: { [weak self] in
                    guard let self = self else { return }
                    self.favoriteButton.isSelected.toggle()
                    self.isFavorited.toggle()
                },
                failure: { error in
                    print("Could not favorite tweet due to \(error)")
                }
            )
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(
                tweetId: tweetId,
                success: { [weak self] in
                    guard let self = self else { return }
                    self.favoriteButton.isSelected.toggle()
                    self.isFavorited.toggle()
                },
                failure: { error in
                    print("Could not unfavorite tweet due to \(error)")
                }
            )
        }
    }
}
