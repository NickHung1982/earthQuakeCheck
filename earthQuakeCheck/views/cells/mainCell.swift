//
//  mainCell.swift
//  earthQuakeCheck
//
//  Created by Nick on 1/20/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import UIKit

class mainCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
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
