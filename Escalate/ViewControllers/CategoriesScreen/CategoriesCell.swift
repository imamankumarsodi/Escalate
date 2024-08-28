//
//  CategoriesCell.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class CategoriesCell: UITableViewCell {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet var viewBackCategories: UIView!
    
    @IBOutlet var imgCategories: UIImageView!
    
    @IBOutlet var lblCategoriesName: UILabel!
    
    @IBOutlet var btnSelectCategoris: UIButton!
    
    
    @IBOutlet weak var imgSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
