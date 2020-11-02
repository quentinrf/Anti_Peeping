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

private let reuseIdentifier = "SettingsCell"

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       // setupTabBar()
        configureUI()
    }
    
//    func setupTabBar() {
//            navigationController?.navigationBar.prefersLargeTitles = true
//            self.navigationItem.title = "Settings"
//            if #available(iOS 13.0, *) {
//                self.navigationController?.navigationBar.barTintColor = .systemBackground
//                 navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
//            } else {
//                self.navigationController?.navigationBar.barTintColor = .lightText
//                navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
//            }
//            self.navigationController?.navigationBar.isHidden = false
//            self.setNeedsStatusBarAppearanceUpdate()
//            self.navigationItem.largeTitleDisplayMode = .automatic
//            self.navigationController?.navigationBar.barStyle = .default
//            if #available(iOS 13.0, *) {
//                navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label]
//            } else {
//                navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
//            }
//            if #available(iOS 13.0, *) {
//                navigationController?.navigationBar.backgroundColor = .systemBackground
//            } else {
//                navigationController?.navigationBar.backgroundColor = .white
//            }
//            self.tabBarController?.tabBar.isHidden = false
//        }
    
    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationItem.title = "Settings"
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Reactionary:
            return ReactionaryOptions.allCases.count
        case .Report:
            return ReportOptions.allCases.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Reactionary:
            let reaction = ReactionaryOptions(rawValue: indexPath.row)
            cell.sectionType = reaction
        case .Report:
            let report = ReportOptions(rawValue: indexPath.row)
            cell.sectionType = report
        }
        
        return cell
    }
    
    
}

