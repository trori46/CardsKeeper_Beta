//
//  MyTableViewCell.swift
//  views
//
//  Created by Victoriia Rohozhyna on 10/28/17.
//  Copyright © 2017 Victoriia Rohozhyna. All rights reserved.
//

import UIKit
import QuartzCore

class MyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var filter: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var frontImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        frontImage.layer.masksToBounds = true
        frontImage.layer.cornerRadius = 10
        filter.layer.masksToBounds = true
        filter.layer.cornerRadius = 10
        // Configure the view for the selected state
    }

}
