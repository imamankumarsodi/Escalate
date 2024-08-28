//
//  SettingsTableViewCell.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet var lblSettingsName: UILabel!
    
    @IBOutlet var switchNotifications: UISwitch!
    @IBOutlet var btnSettingsTapped: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
