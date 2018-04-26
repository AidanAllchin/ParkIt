//
//  BuySpotViewController.swift
//  ParkIt
//
//  Created by Guest User  on 3/11/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class BuySpotViewController: UIViewController {

    @IBOutlet weak var spotLabel: UILabel!
    
    let picker = UIDatePicker()
    
    var spot:ParkingSpot = ParkingSpot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spotLabel.text = "Spot: " + spot.title!
       
    }
    
}
