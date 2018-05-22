//
//  EditSpotViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 5/18/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import Firebase

class EditSpotViewController: UIViewController {
    var spot = ParkingSpot()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //ToViewSpot
        if segue.destination is ViewSpotViewController
        {
            //vc = instance of ViewSpotViewController
            let vc = segue.destination as? ViewSpotViewController
            //Set the spot variable of the ViewSpotViewController to self.spot
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    @IBAction func viewSpot(_ sender: Any) {
        performSegue(withIdentifier: "ToViewSpot", sender: self.spot)
    }
}
