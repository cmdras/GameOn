//
//  GamePlayerCell.swift
//  GameOn
//
//  Created by Christopher Ras on 18/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit

class GamePlayerCell: UITableViewCell {
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerUsername: UILabel!
    @IBOutlet weak var addPlayerButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
