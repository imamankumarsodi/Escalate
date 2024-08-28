//
//  ChatMessageCombineCellAndXib.swift
//  Escalate
//
//  Created by abc on 28/09/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import SwiftSiriWaveformView

class ChatMessageCombineCellAndXib: UITableViewCell {
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    //Purple
    
    
    @IBOutlet weak var imgCornerP: UIImageView!
    
    @IBOutlet weak var viewPurple: UIView!
    
    @IBOutlet weak var lblTotalTimerP: UILabel!
    
    
    
    
    @IBOutlet var btnPlayPausedRefP: UIButton!
    
    
    
    
    @IBOutlet weak var audioViewP: SwiftSiriWaveformView!
    
    @IBOutlet weak var lblTimeP: UILabel!
    
    //White
    
    
    @IBOutlet weak var viewWhite: UIView!
    
    @IBOutlet weak var lblTotalTimerW: UILabel!
    
    
    
    
    @IBOutlet var btnPlayPausedRefW: UIButton!
    
    
    @IBOutlet weak var imgCornerW: UIImageView!
    
    
    @IBOutlet weak var audioViewW: SwiftSiriWaveformView!
    
    @IBOutlet weak var lblTimeW: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
