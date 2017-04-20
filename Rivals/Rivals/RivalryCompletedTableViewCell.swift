//
//  RivalryCompletedTableViewCell.swift
//  Rivals
//
//  Created by Nate Lentz on 4/19/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit

class RivalryCompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
