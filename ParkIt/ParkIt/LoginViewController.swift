//
//  LoginViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 2/13/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var signinSelector: UISegmentedControl!
    
    @IBOutlet weak var signinLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    
    struct UserInformation {
        //static var user: //type
        static var userEmail = ""
        static let userName = ""
    }
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                        UserInformation.userEmail = u.email!
        
                        let def = UserDefaults.standard
                        def.set(String(UserInformation.userEmail), forKey: "userEmail")
                        def.synchronize()
                        
                        //UserInformation.user = u
                        self.performSegue(withIdentifier: "loginComplete", sender: self)
                    }
                    else {
                        let alert = UIAlertController(title: "Login Failed", message: "Login failed: " + (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                        //Error: Check error and show message
                    }
                })
            }
            else {
                //Register the user with Firebase
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    if let u = user {
                        //User is found, go to home screen
                        UserInformation.userEmail = u.email!
                        
                        let def = UserDefaults.standard
                        def.set(String(UserInformation.userEmail), forKey: "userEmail")
                        def.synchronize()
                        
                        self.performSegue(withIdentifier: "loginComplete", sender: self)
                    }
                    else {
                        //Error: Check error and show message
                        let alert = UIAlertController(title: "Creation Failed", message: "Account creation failed: " + (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
