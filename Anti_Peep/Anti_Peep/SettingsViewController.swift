//
//  FaceDetectionViewController.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2020-10-12.
//  Copyright © 2020 XQProductions. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Vision

class SettingsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabBar()
        setupButtons()
    }
    
    func setupTabBar() {
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.title = "Settings"
            if #available(iOS 13.0, *) {
                self.navigationController?.navigationBar.barTintColor = .systemBackground
                 navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
            } else {
                self.navigationController?.navigationBar.barTintColor = .lightText
                navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
            }
            self.navigationController?.navigationBar.isHidden = false
            self.setNeedsStatusBarAppearanceUpdate()
            self.navigationItem.largeTitleDisplayMode = .automatic
            self.navigationController?.navigationBar.barStyle = .default
            if #available(iOS 13.0, *) {
                navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label]
            } else {
                navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
            }
            if #available(iOS 13.0, *) {
                navigationController?.navigationBar.backgroundColor = .systemBackground
            } else {
                navigationController?.navigationBar.backgroundColor = .white
            }
            self.tabBarController?.tabBar.isHidden = false
        }
    
    private func setupButtons() {
        
    }
    
    
    
}

