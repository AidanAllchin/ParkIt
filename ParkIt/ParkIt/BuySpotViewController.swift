//
//  BuySpotViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 3/11/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class BuySpotViewController: UIViewController {

    @IBOutlet weak var spotLabel: UILabel!
    @IBOutlet weak var hourCollectionView: UICollectionView!
    var startTimes: [String] = [String]()
    
    var spot:ParkingSpot = ParkingSpot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spotLabel.text = "Spot: " + spot.title!
    }
}
