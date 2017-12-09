//
//  DriverListPayTableViewCell.swift
//  newDriver
//
//  Created by 凯东源 on 2017/8/10.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import UIKit

class DriverListPayTableViewCell: UITableViewCell {

    // 订单编号
    @IBOutlet weak var ORD_NO: UILabel!
    
    // 客户单号
    @IBOutlet weak var ORD_NO_CLIENT: UILabel!
    
    // 到达名称
    @IBOutlet weak var ORD_TO_NAME: UILabel!
    
    // 到达地址
    @IBOutlet weak var ORD_TO_ADDRESS: UILabel!
    
    // 勾选图片
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    /// 订单信息
    var order: Order! {
        didSet {
            updateUI()
        }
    }
    
    
    internal override func updateUI () {
        if order != nil {
            
            ORD_NO.text = order.ORD_NO;
            ORD_NO_CLIENT.text = order.ORD_NO_CLIENT;
            ORD_TO_NAME.text = order.ORD_TO_NAME;
            ORD_TO_ADDRESS.text = order.ORD_TO_ADDRESS;
            selectedImageView.image = UIImage.init(named: order.cellSelected ? "selected" : "unselect")
        }
    }
}
