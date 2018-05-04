//
//  TimeCell.swift
//  ParkIt
//
//  Created by Aidan Allchin on 5/3/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    init(text: String) {
        self.label.text = text
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "TimeCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
