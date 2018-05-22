//
//  CustomCell.Swift
//  ParkIt
//
//  Created by Will Frohlich on 3/6/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    var item: ViewModelItem? {
        didSet {
            titleLabel?.text = item?.title
            if(item?.isOpen == false){
                self.isUserInteractionEnabled = false
                self.backgroundColor = UIColor.gray
            }
            else if(item?.isRented == true)
            {
                self.isUserInteractionEnabled = false
                self.backgroundColor = UIColor.brown
            }
            else if(item?.isOpen == true)
            {
                self.isUserInteractionEnabled = true
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBOutlet weak var titleLabel: UILabel?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // update UI
        accessoryType = selected ? .checkmark : .none
    }
}
