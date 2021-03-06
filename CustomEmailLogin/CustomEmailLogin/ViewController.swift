//
//  ViewController.swift
//  CustomEmailLogin
//
//  Created by Aidan Allchin on 2/9/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var signinSelector: UISegmentedControl!
    
    @IBOutlet weak var signinLabel: UILabel!
   
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    
    var isSignIn:Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signinSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isSignIn = !isSignIn
        
        //Check boolean and set button and labels
        if isSignIn {
            signinLabel.text = "Login"
            signinButton.setTitle("Login", for: .normal)
        }
        else {
            signinLabel.text = "Register"
            signinButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        //TODO: Form validation on email and password (not empty, password meets requirements, etc.)
        if let email = emailTextField.text, let pass = passwordTextField.text {
            //Check if login or register
            if isSignIn {
                //Sign in user with Firebase
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    //If login was successful, we should get a user. Check that user isn't nil.
                    if let u = user {
                        //User is found, go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else {
                        //Error: Check error and show message
                    }
                })
            }
            else {
                //Register the user with Firebase
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    if let u = user {
                        //User is found, go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else {
                        //Error: Check error and show message
                        print("Password didn't work or email didn't work.")
                    }
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss the keyboard when the view is tapped on
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}

