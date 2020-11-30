//
//  SettingsSection.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2020-11-02.
//  Copyright © 2020 XQProductions. All rights reserved.
//

import Foundation

protocol SectionType: CustomStringConvertible{
    var containsSwitch: Bool { get }
    
}


enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Reactionary
    case Report
    
    var description: String {
        switch self {
        case .Reactionary: return "Reactionary"
        case .Report: return "Report"
        }
    }
}

enum ReactionaryOptions: Int, CaseIterable, SectionType {
    case reaction1
    case reaction2
    
    var containsSwitch: Bool {
        switch self {
        case .reaction1: return true
        case .reaction2: return true
        }
    }
    
    var description: String {
        switch self {
        case .reaction1: return "Close App Upon Detection"
        case .reaction2: return "Dim Screen Upon Detection"
        }
    }
}

enum ReportOptions: Int, CaseIterable, SectionType {
    case reportBug
    case reportPeeper
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .reportBug: return "Report a bug"
        case .reportPeeper: return "Report a Shoulder Peeper"
        }
    }
}
