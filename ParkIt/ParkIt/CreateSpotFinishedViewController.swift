//
//  CreateSpotFinishedViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 3/6/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class CreateSpotFinishedViewController: UIViewController {
    var spot:ParkingSpot = ParkingSpot()

    @IBOutlet weak var spotTitleLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spotTitleLabel.text = spot.title
        addressLabel.text = spot.address
        coordinateLabel.text = "\(spot.coordinate.latitude)" + ", \(spot.coordinate.longitude)"
        
        // Do any additional setup after loading the view.
    }
    
    //Runs the code to create the spot and goes back to the map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UINavigationController
        {
            
        }
    }
    
    //Literally just the segue
    @IBAction func continueButton(_ sender: Any) {
        performSegue(withIdentifier: "BackHome", sender: self.spot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
