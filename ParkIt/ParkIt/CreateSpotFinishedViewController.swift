//
//  CreateSpotFinishedViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 5/1/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class CreateSpotFinishedViewController: UIViewController {
    
    var spot:ParkingSpot = ParkingSpot()
    
    @IBOutlet weak var spotTitle: UILabel!
    @IBOutlet weak var coordinate: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spotTitle.text = spot.title
        address.text = spot.address
        coordinate.text = "\(spot.coordinate.latitude)" + ", \(spot.coordinate.longitude)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
