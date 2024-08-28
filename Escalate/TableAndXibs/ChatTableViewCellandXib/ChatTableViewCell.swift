//
//  ChatTableViewCell.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    @IBOutlet weak var lblNotificationBody: UILabel!
    
    
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
