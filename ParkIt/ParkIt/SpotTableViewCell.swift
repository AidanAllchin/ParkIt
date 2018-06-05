//
//  SpotTableViewCell.swift
//  ParkIt
//
//  Created by Will Frohlich on 5/18/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class SpotTableViewCell: UITableViewCell {

    @IBOutlet weak var spotLabel: UILabel!
    var spot:ParkingSpot = ParkingSpot()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
