//
//  StatCell.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 28/06/2021.
//

import UIKit

class StatCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var moodImgView: UIImageView!
    @IBOutlet weak var lblMoodValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
