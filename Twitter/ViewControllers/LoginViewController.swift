//
//  LoginViewController.swift
//  Twitter
//
//  Created by Denielle Abaquita on 9/18/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = ButtonLayout.largeButtonFont
        button.backgroundColor = Colors.blue
        button.clipsToBounds = true
        button.layer.cornerRadius = ButtonLayout.roundedCornerRadius
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()
    
    let loginURL = "https://api.twitter.com/oauth/request_token"
    let userLoggedInKey = "userLoggedIn"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLoginButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: userLoggedInKey) {
            self.navigateToHome()
        }
    }

    func setupLoginButton() {
        view.addSubview(loginButton)
        
        // Constraints
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/12),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func didTapLogin(_ sender: UIButton) {
        TwitterAPICaller.client?.login(
            url: loginURL,
            success: { [weak self] in
                guard let self = self else { return }
                UserDefaults.standard.setValue(true, forKey: self.userLoggedInKey)
                self.navigateToHome()
            },
            failure: { error in
                print("Can't log in due to \(error)")
            }
        )
    }
    
    private func navigateToHome() {
        let homeVC = HomeViewController()
        let navToHomeController = UINavigationController(rootViewController: homeVC)
        navToHomeController.modalPresentationStyle = .fullScreen
        navToHomeController.navigationBar.isTranslucent = false
        navToHomeController.navigationBar.barTintColor = Colors.blue
        navToHomeController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.show(navToHomeController, sender: self)
    }
}
