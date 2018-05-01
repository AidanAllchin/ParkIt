//
//  BuySpotViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 3/11/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class BuySpotViewController: UIViewController {
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var spotLabel: UILabel!
    
    let items = ["0","1","2","3","4","5","6","7","8","9","10"]
    
    var startTimes: [String] = [String]()
    
    var spot:ParkingSpot = ParkingSpot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        spotLabel.text = "Spot: " + spot.title!
    }
}
