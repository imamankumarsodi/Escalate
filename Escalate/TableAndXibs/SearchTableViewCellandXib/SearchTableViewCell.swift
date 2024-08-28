//
//  SearchTableViewCell.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    
    //MARK:- OUTLETS
    //MARK:-
    
    @IBOutlet weak var imgView_user: UIImageView!
    
    
    @IBOutlet weak var btnFollowRef: UIButton!
    @IBOutlet weak var btnFullName: UIButton!
    
    
    @IBOutlet weak var btnOtherProfileRef: UIButton!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
