//
//  PushOrderTableViewCell.swift
//  newDriver
//
//  Created by 凯东源 on 16/12/15.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class PushOrderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ORD_NO_CLIENT: UILabel!
    @IBOutlet weak var ORD_TO_NAME: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
