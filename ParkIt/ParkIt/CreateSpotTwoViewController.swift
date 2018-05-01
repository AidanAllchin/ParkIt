//
//  CreateSpotTwoViewController.swift
//  ParkIt
//
//  Created by Will Frohlich on 5/1/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class CreateSpotTwoViewController: UIViewController {

    var spot:ParkingSpot = ParkingSpot()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //To send the ParkingSpot to the next page of creation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CreateSpotThreeViewController
        {
            let vc = segue.destination as? CreateSpotThreeViewController
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "NextCreatePage", sender: self.spot)
    }

}
