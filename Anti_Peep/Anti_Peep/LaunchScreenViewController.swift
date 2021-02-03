//
//  LaunchScreenViewController.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2021-01-17.
//  Copyright © 2021 XQProductions. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Vision


class LaunchScreenViewController: UIViewController {
    
    func showActivityIndicatory() {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
   }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        showActivityIndicatory()
        
    }
}
