//
//  alarmCell.swift
//  internationalAlarm
//
//  Created by essdessder on 5/13/20.
//  Copyright © 2020 essdessder. All rights reserved.
//
// Created by Yusen Chen. essdessder is my mac name/ online handle

import UIKit

class alarmCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
