//
//  ComposeViewController.swift
//  MessagingApp
//
//  Created by Aidan Allchin on 2/6/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPost(_ sender: Any) {
        // TODO: Post the data to firebase
        // Dismiss the popover
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        //
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
