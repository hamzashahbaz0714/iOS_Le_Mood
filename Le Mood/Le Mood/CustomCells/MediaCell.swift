//
//  MediaCell.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 28/05/2021.
//

import UIKit

class MediaCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
