//
//  SenderMessageCell.swift
//  Escalate
//
//  Created by abc on 06/09/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import SwiftSiriWaveformView

class SenderMessageCell: UITableViewCell {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet weak var lblTotalTimer: UILabel!
    


    
    @IBOutlet var btnPlayPausedRef: UIButton!


    
    
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    
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
