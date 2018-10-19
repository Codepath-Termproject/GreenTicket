//
//  LogInViewController.swift
//  GroupProject
//
//  Created by SiuChun Kung on 10/17/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInButton(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        if username != "" && password != ""{
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
                if let error = error {
                    print("User log in failed: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Try again", message: error.localizedDescription, preferredStyle: .alert)
                    
                    // add ok button
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                        (action) in
                    })
                    alertController.addAction(okAction)
                    
                    // Show the errorString somewhere and let the user try again.
                    self.present(alertController, animated: true)
                } else {
                    print("User logged in successfully")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    // display view controller that needs to shown after successful login
                }
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        if usernameField.text != "" && passwordField.text != "" {
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    let alertController = UIAlertController(title: "Try again", message: error.localizedDescription, preferredStyle: .alert)
                    
                    // add ok button
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                        (action) in
                    })
                    alertController.addAction(okAction)
                    
                    // Show the errorString somewhere and let the user try again.
                    self.present(alertController, animated: true)
                    
                } else {
                    print("User Registered successfully")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    // manually segue to logged in view
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
