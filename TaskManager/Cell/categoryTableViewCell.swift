//
//  categoryTableViewCell.swift
//  TaskManagerRealm
//
//  Created by Bilal Nawaz on 7/23/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit

class categoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
