//
//  CustomDayCell.swift
//  FCustomCalendar
//
//  Created by Faris on 8/1/20.
//  Copyright © 2020 faris. All rights reserved.
//

import UIKit

class CustomDayCell: JTACDayCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
