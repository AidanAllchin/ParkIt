//
//  AccountViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 3/30/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = UserDefaults.standard.value(forKey: "userEmail") as? String

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
