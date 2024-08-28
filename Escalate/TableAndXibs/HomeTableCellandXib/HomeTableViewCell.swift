//
//  HomeTableViewCell.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import SwiftSiriWaveformView

class HomeTableViewCell: UITableViewCell {
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var btnShowHidePostRef: UIButton!
    
    @IBOutlet weak var lblTotalTimer: UILabel!
    
    @IBOutlet weak var imgView_user: UIImageView!
    
    @IBOutlet weak var lblFullName: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    
    @IBOutlet weak var lblTotalLikes: UILabel!
    
    
    @IBOutlet var btnOtherProfileRef: UIButton!
    
    @IBOutlet var btnPlayPausedRef: UIButton!
    
    @IBOutlet var btnLikeRef: UIButton!
    
    
    @IBOutlet var btnCommentRef: UIButton!
    
    @IBOutlet var btnShareRef: UIButton!
    
    @IBOutlet var btnReplyRef: UIButton!
    
    @IBOutlet var btnViewAllReplyRef: UIButton!
    
    
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
