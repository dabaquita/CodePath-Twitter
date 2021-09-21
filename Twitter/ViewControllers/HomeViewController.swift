//
//  HomeViewController.swift
//  Twitter
//
//  Created by Denielle Abaquita on 9/18/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var tweetDict = [NSDictionary]()
    let customRefreshControl = UIRefreshControl()
    
    var numOfTweets = 10
    let getHomeTimelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Navigation Bar
        self.navigationItem.title = "Home"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .normal
        )
        
        // Load TableView and RefreshControl
        tableView.register(TweetCell.self, forCellReuseIdentifier: TweetCell.identifier)
        loadTweets()
        
        customRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = customRefreshControl
    }
    
    @objc func didTapLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
        self.dismiss(animated: true)
    }
    
    @objc func loadTweets() {
        let loadTweetParams = ["count" : numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(
            url: getHomeTimelineURL,
            parameters: loadTweetParams,
            success: { tweets in
                self.tweetDict.removeAll()
                for tweet in tweets {
                    self.tweetDict.append(tweet)
                }
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            },
            failure: { error in
                print("Could not retrieve tweets due to \(error)")
            }
        )
    }
    
    @objc func loadMoreTweets() {
        numOfTweets += 10
        let loadTweetParams = ["count" : numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(
            url: getHomeTimelineURL,
            parameters: loadTweetParams,
            success: { tweets in
                self.tweetDict.removeAll()
                for tweet in tweets {
                    self.tweetDict.append(tweet)
                }
                self.tableView.reloadData()
            },
            failure: { error in
                print("Could not retrieve tweets due to \(error)")
            }
        )
    }
    
    // MARK: TableView Config
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TweetCell.identifier,
            for: indexPath
        ) as? TweetCell else {
            return UITableViewCell()
        }
        
        let tweet = tweetDict[indexPath.row]
        guard let user = tweet["user"] as? NSDictionary else {
            return cell
        }
        
        cell.profileImageView.image = UIImage(systemName: "pin")
        
        // Profile Name
        if let name = user["name"] as? String {
            cell.profileNameLabel.text = name
        } else {
            cell.profileNameLabel.text = "Name Here"
        }
    
        // Tweet content
        if let tweetContent = tweet["text"] as? String {
            cell.tweetLabel.text = tweetContent
        } else {
            cell.tweetLabel.text = "Content Here"
        }
        
        // Profile Image
        if let imageURLString = user["profile_image_url_https"] as? String,
           let imageURL = URL(string: imageURLString),
           let imageData = try? Data(contentsOf: imageURL) {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 8
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetDict.count {
            loadMoreTweets()
        }
    }
}
