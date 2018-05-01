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
