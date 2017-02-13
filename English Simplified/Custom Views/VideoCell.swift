//
//  VideoCellTableViewCell.swift
//  English Simplified
//
//  Created by Funde, Rohit on 1/9/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import UIKit

class VideoCell : UITableViewCell {
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoDuration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
