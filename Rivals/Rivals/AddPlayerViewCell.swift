//
//  AddPlayerViewCell.swift
//  Rivals
//
//  Created by Nate Lentz on 4/16/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit

class AddPlayerViewCell: UITableViewCell {

    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var winsLosses: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
