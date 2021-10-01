//
//  CreateTweetViewController.swift
//  Twitter
//
//  Created by Denielle Abaquita on 9/27/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class CreateTweetViewController: UIViewController {
    
    let tweetTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        // Load navigation bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .normal
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Tweet",
            style: .done,
            target: self,
            action: #selector(didTapTweet)
        )
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .normal
        )
        
        // Load subviews
    }

    @objc func didTapCancel(_ sender: Any?) {
        self.dismiss(animated: true)
        print("Tapped Cancel")
    }
    
    @objc func didTapTweet(_ sender: Any?) {
        print("Tapped Tweet")
    }
    
    // Format subviews
}
