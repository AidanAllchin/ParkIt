//
//  AddPinViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 2/27/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class AddPinViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let contentsView : UIView = UIView()
        var scrollView : UIScrollView = UIScrollView(frame: contentsView.frame)
        
        
        let iv : UIButton = UIButton(frame: CGRect(x: 10, y: 10, width: 200, height: 200))
        iv.setTitle("Hello", for: .normal)
        self.view.addSubview(iv)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
