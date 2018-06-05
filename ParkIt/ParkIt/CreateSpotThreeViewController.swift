//
//  CreateSpotThreeViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 5/1/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class CreateSpotThreeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleField: UITextField!
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    var numSpots = 0
    var uniqueId = ""
    
    var spot:ParkingSpot = ParkingSpot()

    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        //sets up delegates for the text field
        self.titleField.delegate = self
        
        for _ in 0...32 {
            uniqueId = uniqueId + String(Int(arc4random_uniform(10)))
        }
        
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            //We determine how many spots there are in the database and set the name of the spot
            let wholeDatabase: NSDictionary = snapshot.value as! NSDictionary
            let spots: NSDictionary = wholeDatabase.value(forKey: "Spots") as! NSDictionary
            
            self.numSpots = spots.count
        })
        
        // Do any additional setup after loading the view.
    }
    
    //Closes any keyboard open when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        return (true)
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
            
            self.ref.child("Spots").child(uniqueId).setValue(["title": spot.title])
            self.ref.child("Spots/\(uniqueId)/id").setValue(uniqueId)
            self.ref.child("Spots/\(uniqueId)/address").setValue(spot.address)
            let coordinates = String(spot.coordinate.latitude) + ", " + String(spot.coordinate.longitude)
            self.ref.child("Spots/\(uniqueId)/location").setValue(coordinates)
            self.ref.child("Spots/\(uniqueId)/timeLeft").setValue(0)
            self.ref.child("Spots/\(uniqueId)/isAvailable").setValue(0)
            let userSelling = UserDefaults.standard.value(forKey: "userEmail") as! String
            self.ref.child("Spots/\(uniqueId)/userSelling").setValue(userSelling)
            self.ref.child("Spots/\(uniqueId)/userBuying").setValue("")
            self.ref.child("Spots/\(uniqueId)/isCovered").setValue(0)
            
            //Setting timesAvailable
            var i = 0
            for time in spot.timesAvailable
            {
                let timeNumber = String(format: "%02d", (i))
                self.ref.child("Spots/\(uniqueId)/TimesAvailable/Time-" + timeNumber).setValue(time)
                i = i + 1
            }
        }
    }
    
    //This sets the title to the spot title, and prompts the user if there isn't text there.
    @IBAction func nextButton(_ sender: Any) {
        if(titleField.text != "")
        {
            spot.title = titleField.text
            performSegue(withIdentifier: "NextCreatePage", sender: self.spot)
        }
        else
        {
            let alert = UIAlertController(title: "Title Missing", message: "Please enter a spot title before continuing", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    //Gets rid of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss the keyboard when the view is tapped on
        titleField.resignFirstResponder()
    }
}
