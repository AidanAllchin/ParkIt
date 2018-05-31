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
    @IBOutlet weak var titleTextField: UITextField!
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    var numSpots = 0
    var didCancel: Bool = false
    var changesCanceled: Bool = false
    
    var spot = ParkingSpot()

    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        titleTextField.text = spot.title
        didCancel = false
        
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            //We determine how many spots there are in the database and set the name of the spot
            let wholeDatabase: NSDictionary = snapshot.value as! NSDictionary
            let spots: NSDictionary = wholeDatabase.value(forKey: "Spots") as! NSDictionary
            
            self.numSpots = spots.count
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewSpotViewController && changesCanceled == false
        {
            let spotNumber = String(format: "%04d", (self.numSpots - 1))

            if (titleTextField.text != "")
            {
                spot.title = titleTextField.text
                self.ref.child("Spots/Spot-0x\(spotNumber)/Title").setValue(spot.title)
            } else {
                let alert = UIAlertController(title: "Title Empty", message: "Please enter a valid title before continuing", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            
            //vc = instance of ViewSpotViewController
            let vc = segue.destination as? ViewSpotViewController
            //Set the spot variable of the ViewSpotViewController to self.spot
            vc!.spot = sender as! ParkingSpot
        }
        else// if segue.destination is UINavigationController
        {
            /*let alert = UIAlertController(title: "Confirm", message: "Do you really want to delete this spot?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.didCancel = false
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                self.didCancel = true
            }))
            
            self.present(alert, animated: true)*/
        }
    }
    @IBAction func makeChanges(_ sender: Any) {
        changesCanceled = false
        performSegue(withIdentifier: "ToViewSpot", sender: self.spot)
    }
    
    //TODO: if user pushes delete spot, go straight back to the main page
    @IBAction func viewSpot(_ sender: Any) {
        changesCanceled = true
        performSegue(withIdentifier: "ToViewSpot", sender: self.spot)
    }
    
    @IBAction func deleteSpot(_ sender: Any) {
        if !didCancel {
            performSegue(withIdentifier: "DeleteSpot", sender: self)
        }
    }
    
    //Gets rid of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss the keyboard when the view is tapped on
        titleTextField.resignFirstResponder()
    }
}