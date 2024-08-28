//
//  FollowFollowingXibAndCe.swift
//  Escalate
//
//  Created by abc on 13/08/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class FollowFollowingXibAndCe: UITableViewCell {
    @IBOutlet weak var imgView_user: UIImageView!
    
    
    @IBOutlet weak var btnPlayBioRef: UIButton!
    
    @IBOutlet weak var btnFollowRef: UIButton!
    @IBOutlet weak var btnFullName: UIButton!
    
    
    @IBOutlet weak var btnOtherProfileRef: UIButton!
    
    
    @IBOutlet weak var btnMuteUnmuteTapped: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
