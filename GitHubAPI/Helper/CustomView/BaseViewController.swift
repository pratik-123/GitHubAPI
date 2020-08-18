//
//  BaseViewController.swift
//  GitHubAPI
//
//  Created by Pratik on 18/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    var loaderView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Display alert view controller
    /// - Parameters:
    ///   - title: title string (default value = "GitHubAPI")
    ///   - message: message string
    ///   - actions: button actions (default value = nil  and set "OK" action button)
    func showAlert(withTitle title: String = "GitHubAPI", message: String?, actions: [UIAlertAction]? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ///check if multiple action pass then set otherwise add simple OK button action
            if let actions = actions, actions.isEmpty == false {
                for action in actions {
                    alert.addAction(action)
                }
            } else {
                alert.addAction(UIAlertAction(title: "OK", style: .default))
            }
            self.present(alert, animated: true)
        }
    }
    
    /// Display activity indicator
    /// - Parameter onView: presentation view
    func displayActivityIndicator(onView : UIView) {
        let containerView = UIView.init(frame: onView.bounds)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = containerView.center
        DispatchQueue.main.async {
            containerView.addSubview(activityIndicator)
            onView.addSubview(containerView)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loaderView = containerView
    }
    
    /// Remove activity indicator
    func removeActivityIndicator() {
        DispatchQueue.main.async {
            self.loaderView?.removeFromSuperview()
            self.loaderView = nil
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
