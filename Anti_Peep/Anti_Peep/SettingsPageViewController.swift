//
//  SettingsPageViewController.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2021-02-28.
//  Copyright © 2021 XQProductions. All rights reserved.
//

import Foundation
import UIKit


struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    var isOn: Bool
}



struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

class SettingsPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        configure()
        title = "Settings"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func configure() {
        models.append(Section(title: "System Control", options: [
            .switchCell(model: SettingsSwitchOption(title: "Toggle Face Detection", icon: UIImage(systemName: "person.crop.circle.badge.exclam"), iconBackgroundColor: .systemPink, handler: {
                
            }, isOn: true)),
            .switchCell(model: SettingsSwitchOption(title: "Toggle Gaze Detection", icon: UIImage(systemName: "eye"), iconBackgroundColor: .link, handler: {
                
            }, isOn: true)),
    ]))
        models.append(Section(title: "Reactionary Measures", options: [
            .switchCell(model: SettingsSwitchOption(title: "Close Application", icon: UIImage(systemName: "power"), iconBackgroundColor: .systemRed, handler: {
                    
            }, isOn: true)),
            .switchCell(model: SettingsSwitchOption(title: "Flash Screen Brightness", icon: UIImage(systemName: "sunset"), iconBackgroundColor: .systemOrange, handler: {
                    
            }, isOn: true)),
    ]))
        models.append(Section(title: "Reporting Section", options: [
            .staticCell(model: SettingsOption(title: "Report a Shoulder Peeper", icon: UIImage(systemName: "hand.raised"), iconBackgroundColor: .systemPink){
            }),
            .staticCell(model: SettingsOption(title: "Report a Bug in the Application", icon: UIImage(systemName: "ladybug"), iconBackgroundColor: .link){
            }),
    ]))
    }
    
    func setupTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Settings"
        }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingTableViewCell.identifier,
                    for: indexPath
            ) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SwitchTableViewCell.identifier,
                    for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
    
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        }
        
    }
    
}
