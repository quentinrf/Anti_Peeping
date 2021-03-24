//
//  SettingsPageViewController.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2021-02-28.
//  Copyright © 2021 XQProductions. All rights reserved.
//

import Foundation
import UIKit

protocol settingsToggleDelegate {
    func toggleBrightnessReaction()
    func toggleExitAppReaction(isOn: Bool)
}

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
    
    var brightToggleIsOn = true
    var offToggleIsOn = true
    
    var delegate: settingsToggleDelegate?
    
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
        models.append(Section(title: "Reactionary Measures", options: [
            .switchCell(model: SettingsSwitchOption(title: "Close Application", icon: UIImage(systemName: "power"), iconBackgroundColor: .systemRed, handler: {
                self.setOffToggle()
            }, isOn: false)),
            .switchCell(model: SettingsSwitchOption(title: "Flash Screen Brightness", icon: UIImage(systemName: "sunset"), iconBackgroundColor: .systemOrange, handler: {
                self.delegate?.toggleBrightnessReaction()
            }, isOn: false)),
    ]))
        models.append(Section(title: "Reporting Section", options: [
            .staticCell(model: SettingsOption(title: "Report a Shoulder Peeper", icon: UIImage(systemName: "hand.raised"), iconBackgroundColor: .systemPink){
            }),
            .staticCell(model: SettingsOption(title: "Report a Bug in the Application", icon: UIImage(systemName: "ladybug"), iconBackgroundColor: .link){
            }),
    ]))
    }
    
    func setBrightToggle(){
        //models[1].options[1].self.
        //brightToggleIsOn.toggle()
        //delegate?.toggleBrightnessReaction(isOn: models[0].options[1])
    }
    func setOffToggle(){
        //offToggleIsOn.toggle()
      //  print(offToggleIsOn)
       // delegate?.toggleExitAppReaction(isOn: offToggleIsOn)
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
