//
//  CreateSpotThreeViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 5/1/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class CreateSpotThreeViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    
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
        if segue.destination is CreateSpotFinishedViewController
        {
            let vc = segue.destination as? CreateSpotFinishedViewController
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "NextCreatePage", sender: self.spot)
    }
}
