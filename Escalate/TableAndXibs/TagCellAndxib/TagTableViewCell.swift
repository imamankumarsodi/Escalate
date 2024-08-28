//
//  TagTableViewCell.swift
//  Escalate
//
//  Created by abc on 14/11/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
