//
//  ViewController.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2020-09-28.
//  Copyright © 2020 XQProductions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let name: UILabel = {
           let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont(name: "Avenir-Heavy", size: 50)
            text.text = "Anti Peep"
            text.textColor = .label
            return text
            
        }()
    
    let faceMask: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToFaceMask(_:)), for: .touchUpInside)
        button.setTitle("  Face mask", for: .normal)
        //let icon = UIImage(systemName: "eye")//?.resized(newSize: CGSize(width: 50, height: 30))
        //button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = .systemTeal
        button.layer.borderColor = UIColor.systemTeal.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.systemTeal.cgColor
        return button
    }()
    
    let faceDetection: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToFaceDetection(_:)), for: .touchUpInside)
        button.setTitle("  Face detection", for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.borderColor = UIColor.systemTeal.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.systemTeal.cgColor

        return button
    }()
    
    let settings: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToSettings(_:)), for: .touchUpInside)
        button.setTitle("  Settings", for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.borderColor = UIColor.systemTeal.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.systemTeal.cgColor

        return button
    }()

//    let objectDetection: BtnPleinLarge = {
//        let button = BtnPleinLarge()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(buttonToObjectDetection(_:)), for: .touchUpInside)
//        button.setTitle("Object detection", for: .normal)
//        let icon = UIImage(systemName: "crop")?.resized(newSize: CGSize(width: 50, height: 50))
//        button.addRightImage(image: icon!, offset: 30)
//        button.backgroundColor = .systemPurple
//        button.layer.borderColor = UIColor.systemPurple.cgColor
//        button.layer.shadowOpacity = 0.3
//        button.layer.shadowColor = UIColor.systemPurple.cgColor
//
//        return button
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabBar()
        setupLabel()
        setupButtons()
    }
    
    func setupTabBar() {
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.title = "Anti Peep"
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
        
        private func setupLabel() {
            view.addSubview(name)
            name.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            name.heightAnchor.constraint(equalToConstant: 100).isActive = true
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            name.numberOfLines = 1
        }
    
    
    
    
    private func setupButtons() {
        
        view.addSubview(faceMask)
        view.addSubview(faceDetection)
        view.addSubview(settings)
//        view.addSubview(objectDetection)
        
        faceMask.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceMask.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        faceMask.heightAnchor.constraint(equalToConstant: 70).isActive = true
        faceMask.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        faceDetection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceDetection.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        faceDetection.heightAnchor.constraint(equalToConstant: 70).isActive = true
        faceDetection.topAnchor.constraint(equalTo: faceMask.bottomAnchor, constant: 30).isActive = true
        
        settings.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settings.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        settings.heightAnchor.constraint(equalToConstant: 70).isActive = true
        settings.topAnchor.constraint(equalTo: faceDetection.bottomAnchor, constant: 30).isActive = true
//        
//        objectDetection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        objectDetection.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
//        objectDetection.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        objectDetection.topAnchor.constraint(equalTo: faceClassification.bottomAnchor, constant: 30).isActive = true
    }
    
    
    @objc func buttonToFaceMask(_ sender: BtnPleinLarge) {
        
        let controller = FaceMaskViewController()

        let navController = UINavigationController(rootViewController: controller)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    //Face Detection Button
    
    @objc func buttonToFaceDetection(_ sender: BtnPleinLarge) {
           
       let controller = FaceDetectionViewController()

       let navController = UINavigationController(rootViewController: controller)
       
       self.present(navController, animated: true, completion: nil)
    }
    
    //Settings Page Button
    
    @objc func buttonToSettings(_ sender: BtnPleinLarge) {
           
       let controller = SettingsViewController()

       let navController = UINavigationController(rootViewController: controller)
       
       self.present(navController, animated: true, completion: nil)
    }
    
    
    
//    
//    @objc func buttonToFaceClassification(_ sender: BtnPleinLarge) {
//           
//       let controller = FaceClassificationViewController()
//
//       let navController = UINavigationController(rootViewController: controller)
//       
//       self.present(navController, animated: true, completion: nil)
//    }
//    
//    @objc func buttonToObjectDetection(_ sender: BtnPleinLarge) {
//           
//       let controller = ObjectDetectionViewController()
//
//       let navController = UINavigationController(rootViewController: controller)
//       
//       self.present(navController, animated: true, completion: nil)
//    }


}

