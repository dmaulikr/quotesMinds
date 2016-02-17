//
//  authorsTableViewCell.swift
//  everyday
//
//  Created by thiagoracca on 2/4/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

class authorsTableViewCell: UITableViewCell,userModel, logHelper {
    var logLevel : Int = 3
    
    @IBOutlet var authorImage : UIImageView!
    @IBOutlet var labelName : UILabel!
    @IBOutlet var btnSelect : UIButton!
    
    var slotId : Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
