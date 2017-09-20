//
//  ThemeManager.swift
//  MimoiOSCodingChallenge
//
//  Created by Daniel Torres on 9/19/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation

class ThemeManager : NSObject{
    
    static let selectedThemeKey = "SelectedTheme"
    
    static func currentTheme() -> Int {
        if let storedTheme = UserDefaults.standard.value(forKey: selectedThemeKey) as? Int {
            return storedTheme
        } else {
            return 0
        }
    }
    static func applyTheme(theme: Int) {
        let darkmode = theme == 1 ? true : false
        UserDefaults.standard.set(darkmode, forKey: selectedThemeKey)
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            let theme = Theme(rawValue: theme)!

            UIButton.appearance().tintColor = theme.buttonfore
            UIButton.appearance().backgroundColor = theme.buttonback
            
            UITextField.appearance().backgroundColor = theme.texfieldBack
            UITextField.appearance().tintColor = theme.textFieldFore
            
            UIActivityIndicatorView.appearance().color = theme.indicator
            
            UITableViewCell.appearance().backgroundColor = theme.mainColor
            UITableView.appearance().backgroundColor = theme.mainColor
            
            UISwitch.appearance().thumbTintColor = theme.switchThumbnail
            UISwitch.appearance().onTintColor = theme.switchOn
        }
    }
}

enum Theme : Int {
    case Default, Dark
    
    var switchThumbnail: UIColor{
        switch self {
        case .Default:
            return UIColor.green
        case .Dark:
            return UIColor.orange
        }
    }
    
    var switchOn: UIColor{
        switch self {
        case .Default:
            return UIColor.green.withAlphaComponent(0.3)
        case .Dark:
            return UIColor.orange.withAlphaComponent(0.3)
        }
    }
    
    
    var viewBackGround: UIColor{
        switch self {
            case .Default:
                return UIColor.white
            case .Dark:
                return UIColor.gray
        }
    }
    
    var labelColor: UIColor {
        switch self {
        case .Default:
            return UIColor.black
        case .Dark:
            return UIColor.white
        }
        
    }
    
    
    var mainColor: UIColor {
        switch self {
        case .Default:
            return UIColor.white
        case .Dark:
            return UIColor.darkGray
        }
    }
    
    var texfieldBack: UIColor{
        switch self {
        case .Default:
            return UIColor.clear
        case .Dark:
            return UIColor.white
        }
    }
    var textFieldFore: UIColor{
        switch self {
        case .Default:
            return UIColor.blue
        case .Dark:
            return UIColor.darkGray
        }
    }
    
    var indicator: UIColor{
        switch self {
        case .Default:
            return UIColor.lightGray
        case .Dark:
            return UIColor.white
        }
    }
    
    var buttonfore: UIColor{
        switch self {
        case .Default:
            return UIColor.blue
        case .Dark:
            return UIColor.white
        }
    }
    var buttonback: UIColor{
        switch self {
        case .Default:
            return UIColor.clear
        case .Dark:
            return UIColor.lightGray
        }
    }
}
