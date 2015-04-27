//
//  PlayerCell.swift
//  CrowdSound
//
//  Created by Jared Katzman on 4/8/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {

    //
    
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
