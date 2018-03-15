//
//  BuySpotViewController.swift
//  ParkIt
//
//  Created by Guest User  on 3/11/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class BuySpotViewController: UIViewController {

    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker(dateField: startDateField)
        createDatePicker(dateField: endDateField)
        // Do any additional setup after loading the view.
    }
    
    func createDatePicker(dateField:UITextField) {
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button
        if dateField == startDateField {
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDonePressed))
                toolbar.setItems([done], animated: false)
        }
        else {
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDonePressed))
            toolbar.setItems([done], animated: false)
        }
        
        dateField.inputAccessoryView = toolbar
        dateField.inputView = picker
    }
    
    @objc func startDonePressed(dateField:UITextField){
        startDateField.text = "\(picker.date)"
        self.view.endEditing(true)
    }
    
    @objc func endDonePressed(dateField:UITextField){
        endDateField.text = "\(picker.date)"
        self.view.endEditing(true)
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
