//
//  WelcomePageViewController.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2021-03-24.
//  Copyright © 2021 XQProductions. All rights reserved.
//

import Foundation
import UIKit


class WelcomePageViewController: UIViewController {
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            setupButtons()
            setupLabel()
            setupTabBar()
        }
    
    
    let app_title: UILabel = {
           let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont(name: "Avenir-Heavy", size: 30)
            text.text = "Welcome to Anti-Peep!"
            text.textColor = .label
            return text
            
        }()
    
    let app_description_line1: UILabel = {
           let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont(name: "Avenir-Heavy", size: 18)
            text.text = "Please explore the application's"
            text.textColor = .label
            return text
            
        }()
    
    let app_description_line2: UILabel = {
           let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont(name: "Avenir-Heavy", size: 18)
            text.text = "features through the buttons below!"
            text.textColor = .label
            return text
            
        }()
    
    
    
    let faceDetectionBTN: BtnPleinLarge = {
            let button = BtnPleinLarge()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonToFD(_:)), for: .touchUpInside)
        button.setTitle("Face Detection", for: .normal)
            let icon = UIImage(systemName: "faceid")?.resized(newSize: CGSize(width: 50, height: 45))
            //icon.tintColor(.white)
            button.addRightImage(image: icon!, offset: 30)
            button.backgroundColor = .systemBlue
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.shadowOpacity = 0.3
            button.layer.shadowColor = UIColor.systemBlue.cgColor
            
            return button
        }()
    
    
    let gazeTrackingBTN: BtnPleinLarge = {
            let button = BtnPleinLarge()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonToGaze(_:)), for: .touchUpInside)
            button.setTitle("Gaze Tracking", for: .normal)
            let icon = UIImage(systemName: "eye")?.resized(newSize: CGSize(width: 50, height: 35))
            icon?.withTintColor(.white)
            button.addRightImage(image: icon!, offset: 30)
            button.backgroundColor = .systemBlue
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.shadowOpacity = 0.3
            button.layer.shadowColor = UIColor.systemBlue.cgColor
            
            return button
        }()
    
    private func setupLabel() {
            view.addSubview(app_title)
            app_title.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            app_title.heightAnchor.constraint(equalToConstant: 100).isActive = true
            app_title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            app_title.numberOfLines = 1
            
            view.addSubview(app_description_line1)
            app_description_line1.topAnchor.constraint(equalTo: app_title.bottomAnchor, constant: 10).isActive = true
            app_description_line1.heightAnchor.constraint(equalToConstant: 20).isActive = true
            app_description_line1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            app_description_line1.numberOfLines = 1
        
            view.addSubview(app_description_line2)
            app_description_line2.topAnchor.constraint(equalTo: app_description_line1.bottomAnchor, constant: 10).isActive = true
            app_description_line2.heightAnchor.constraint(equalToConstant: 20).isActive = true
            app_description_line2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            app_description_line2.numberOfLines = 1
        }
    
    
    func setupTabBar() {
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.title = "Anti-Peep"
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
            
            view.addSubview(faceDetectionBTN)
            view.addSubview(gazeTrackingBTN)
            
            faceDetectionBTN.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            faceDetectionBTN.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            faceDetectionBTN.heightAnchor.constraint(equalToConstant: 70).isActive = true
            faceDetectionBTN.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                
            gazeTrackingBTN.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            gazeTrackingBTN.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            gazeTrackingBTN.heightAnchor.constraint(equalToConstant: 70).isActive = true
            gazeTrackingBTN.topAnchor.constraint(equalTo: faceDetectionBTN.bottomAnchor, constant: 30).isActive = true
        }
    
    
    @objc func buttonToFD(_ sender: BtnPleinLarge) {
            
            let controller = ViewController()

            let navController = UINavigationController(rootViewController: controller)
            
            self.present(navController, animated: true, completion: nil)
        }
    
    
    @objc func buttonToGaze(_ sender: BtnPleinLarge) {
            
            let controller = TransformViewController()

            let navController = UINavigationController(rootViewController: controller)
            
            self.present(navController, animated: true, completion: nil)
        }
    
    
}
