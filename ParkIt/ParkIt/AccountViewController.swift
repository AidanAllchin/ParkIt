    //
//  AccountViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 3/30/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    @IBOutlet weak var sellingOneButton: UIButton!
    @IBOutlet weak var sellingTwoButton: UIButton!
    @IBOutlet weak var sellingThreeButton: UIButton!
    @IBOutlet weak var sellingFourButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var spotOne = ParkingSpot()
    var spotTwo = ParkingSpot()
    var spotThree = ParkingSpot()
    var spotFour = ParkingSpot()
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        
        usernameLabel.text = UserDefaults.standard.value(forKey: "userEmail") as? String
        
        //Setting spots the user is selling
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            let spots: NSDictionary = (snapshot.value as! NSDictionary).value(forKey: "Spots") as! NSDictionary
            
            var spotName = ""
            
            let numSpots = spots.count
            var currentSpotNum = numSpots - 1
            
            //Start cycling through all the spots and find which one has the same id as the spot that was clicked on for purchase
            let jj = 0
            while jj <= currentSpotNum
            {
                spotName = "Spot-0x" + String(format: "%04d", currentSpotNum)
                let dict: NSDictionary = spots.value(forKey: spotName) as! NSDictionary
                let userSelling = dict.value(forKey: "userSelling") as! String
                
                if (userSelling == UserDefaults.standard.value(forKey: "userEmail") as? String)
                {
                    if (self.sellingOneButton.currentTitle == "SellingOne") {
                        self.spotOne = ParkingSpot(dict: dict)
                        self.sellingOneButton.setTitle(dict.value(forKey: "title") as? String, for: UIControlState.normal)
                    } else if (self.sellingTwoButton.currentTitle == "SellingTwo") {
                        self.spotTwo = ParkingSpot(dict: dict)
                        self.sellingTwoButton.setTitle(dict.value(forKey: "title") as? String, for: UIControlState.normal)
                    } else if (self.sellingThreeButton.currentTitle == "SellingThree") {
                        self.spotThree = ParkingSpot(dict: dict)
                        self.sellingThreeButton.setTitle(dict.value(forKey: "title") as? String, for: UIControlState.normal)
                    } else if (self.sellingFourButton.currentTitle == "SellingFour") {
                        self.spotFour = ParkingSpot(dict: dict)
                        self.sellingFourButton.setTitle(dict.value(forKey: "title") as? String, for: UIControlState.normal)
                    }
                }
                currentSpotNum = currentSpotNum - 1
            }
            if (self.sellingOneButton.currentTitle == "SellingOne") {
                self.sellingOneButton.setTitle("Not selling any spots currently.", for: UIControlState.normal)
            } else if (self.sellingTwoButton.currentTitle == "SellingTwo") {
                self.sellingTwoButton.isHidden = true
            } else if (self.sellingThreeButton.currentTitle == "SellingThree") {
                self.sellingThreeButton.isHidden = true
            } else if (self.sellingFourButton.currentTitle == "SellingFour") {
                self.sellingFourButton.isHidden = true
            }
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewSpotViewController
        {
            let vc = segue.destination as? ViewSpotViewController
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    @IBAction func toViewSpotOne(_ sender: Any) {
        performSegue(withIdentifier: "ToViewSpot", sender: self.spotOne)
    }
    
    @IBAction func toViewSpotTwo(_ sender: Any) {
        performSegue(withIdentifier: "ToViewSpot", sender: self.spotTwo)
    }
    
    @IBAction func toViewSpotThree(_ sender: Any) {
        performSegue(withIdentifier: "ToViewSpot", sender: self.spotThree)
    }
    
    @IBAction func toViewSpotFour(_ sender: Any) {
        performSegue(withIdentifier: "ToViewSpot", sender: self.spotFour)
    }
}
