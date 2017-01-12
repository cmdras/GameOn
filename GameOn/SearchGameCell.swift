//
//  SearchGameCell.swift
//  GameOn
//
//  Created by Christopher Ras on 12/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit

class SearchGameCell: UITableViewCell {
    @IBOutlet weak var searchGameImage: UIImageView!
    @IBOutlet weak var searchGameTitle: UILabel!
    @IBOutlet weak var searchGameRelease: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
