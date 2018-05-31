//
//  CustomTableViewCell.swift
//  CheckMate
//
//  Created by Kelly Luo on 4/27/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLayer: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bill: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
