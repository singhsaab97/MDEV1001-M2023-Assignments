//
//  RootLauncher.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import UIKit
import FirebaseCore

final class RootLauncher {
    
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        setup()
    }
    
}

// MARK: - Exposed Helpers
extension RootLauncher {
    
    func launch() {
        let viewController = AuthenticationViewController.loadFromStoryboard()
        let viewModel = AuthenticationViewModel(flow: .signIn, listener: self)
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        window?.rootViewController = viewController.embeddedInNavigationController
        window?.makeKeyAndVisible()
    }
    
}

// MARK: - Private Helpers
private extension RootLauncher {
    
    func setup() {
        FirebaseApp.configure()
        setUserInterfaceStyle(with: UserDefaults.userInterfaceStyle)
    }
    
    func setUserInterfaceStyle(with style: UIUserInterfaceStyle) {
        window?.overrideUserInterfaceStyle = style
    }
    
}

// MARK: - AuthenticationListener Methods
extension RootLauncher: AuthenticationListener {
    
    func changeTheme(to style: UIUserInterfaceStyle) {
        guard let view = window else { return }
        UIView.transition(with: view, duration: Constants.animationDuration) { [weak self] in
            self?.setUserInterfaceStyle(with: style)
        }
    }
   
}
