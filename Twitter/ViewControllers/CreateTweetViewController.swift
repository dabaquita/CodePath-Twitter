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
    let placeholderText = "New Tweet..."

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
        configureTweetTextView()
    }

    @objc func didTapCancel(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
    @objc func didTapTweet(_ sender: Any?) {
        if !tweetTextView.text.isEmpty && tweetTextView.text != placeholderText {
            TwitterAPICaller.client?.postTweet(
                tweetString: tweetTextView.text,
                success: {
                    self.dismiss(animated: true, completion: nil)
                },
                failure: { error in
                    print("Error posting tweet due to \(error)")
                    self.dismiss(animated: true, completion: nil)
                }
            )
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Format subviews
    func configureTweetTextView() {
        tweetTextView.delegate = self
        tweetTextView.text = placeholderText
        tweetTextView.textColor = UIColor.lightGray
        tweetTextView.font = .systemFont(ofSize: 17)
        tweetTextView.becomeFirstResponder()
        view.addSubview(tweetTextView)
        
        // Constraints
        tweetTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tweetTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            tweetTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tweetTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tweetTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }
}

extension CreateTweetViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine textView text and replacement
        let currentText: String = tweetTextView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // Add placeholder and set cursor to beginning of text view
        if updatedText.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument
            )
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = .black
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
}
