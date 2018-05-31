//
//  PeopleTableViewCell.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/25/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    @IBOutlet weak var peopleCeil: UIView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
