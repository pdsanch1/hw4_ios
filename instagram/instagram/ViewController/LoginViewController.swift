//
//  LoginViewController.swift
//  instagram
//
//  Created by Pedro Daniel Sanchez on 9/30/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        PFUser.logInWithUsername(inBackground: username, password: password) { (user:PFUser?, error:Error?) in
            if user != nil { // same as if let user = user
                print("login SUCCESSFUL !!")
                print("Username: \(PFUser.current()!.username! as String)")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Invalid USER")
                let err = error as NSError?
                if err!.code == 201 {
                    print("Password is empty !")
                }
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground { (success: Bool, error:Error?) -> Void in
            if success {
                print("Yeeessss !, created a user")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                print(error?.localizedDescription as Any)
                let err = error as NSError?
                if err!.code == 202 {
                    print("username is taken")
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
