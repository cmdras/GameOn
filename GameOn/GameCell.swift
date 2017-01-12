//
//  GameCell.swift
//  GameOn
//
//  Created by Christopher Ras on 12/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameRelease: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
