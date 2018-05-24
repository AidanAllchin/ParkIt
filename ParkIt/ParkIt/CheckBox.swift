//
//  CheckBox.swift
//  ParkIt
//
//  Created by Aidan Allchin on 5/22/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checkedCheckbox")! as UIImage
    let uncheckedImage = UIImage(named: "uncheckedCheckbox")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton!) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
