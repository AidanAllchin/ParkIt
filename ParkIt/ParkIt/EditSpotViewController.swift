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
    
    var spot = ParkingSpot()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = spot.title
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewSpotViewController
        {
            if (titleTextField.text != "")
            {
                spot.title = titleTextField.text
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
    }
    
    @IBAction func viewSpot(_ sender: Any) {
        performSegue(withIdentifier: "ToViewSpot", sender: self.spot)
    }
}
