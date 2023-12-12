//
//  ActivityCell.swift
//  TouristActivitiesApp
//
//  Created by iMac on 21/11/21.
//

import UIKit

class ActivityCell: UITableViewCell {

    
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
