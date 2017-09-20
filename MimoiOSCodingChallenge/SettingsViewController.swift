//
//  Created by Mimohello GmbH on 16.02.17.
//  Copyright (c) 2017 Mimohello GmbH. All rights reserved.
//
	
extension SettingsViewController : SettingsTableViewCellDelegate {
	
	func switchChangedValue(switcher: UISwitch) {
        let theme : Theme = switcher.isOn ? Theme.Dark : Theme.Default
        ThemeManager.applyTheme(theme: theme.rawValue)
	}
    
}


