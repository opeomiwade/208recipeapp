//
//  LoginViewController.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 15/03/2022.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    //MARK: IBOUTLETS
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var passwordtext: UITextField!
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordtext.autocorrectionType = .no
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
       
    
    //MARK: IBACTION METHOD
    @IBAction func buttonpressed(_ sender: Any) {
        //Validate text fields
        if(emailtext.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordtext.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "A field or all fields are empty", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            //print("both empty")
        }
        
        //log user into account
        let email = emailtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //MARK: USER AUTHENTICATION AND VALIDATION
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil{
                let error = error!.localizedDescription
                print(error)
                if error == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    let alert = UIAlertController(title: error, message: "Would you like to a create user?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "logintosignup", sender: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                        let alert = UIAlertController(title: "You cannot log in ", message: "You must go back and create an account", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.performSegue(withIdentifier: "returntoinitial", sender: nil)
                        }))
                        self.present(alert, animated: true)
                    }))
                    self.present(alert, animated: true)
                }
                
                else if(error == "The password is invalid or the user does not have a password." ){
                    let alert = UIAlertController(title: "Invalid passowrd", message: "You have entered the wrong password for this account", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default))
                    alert.addAction(UIAlertAction(title: "Forgot Password?", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "logintoforgotpassword", sender: nil)
                    }))
                    self.present(alert, animated: true)
                }
                
                else if(error == "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."){
                    
                    let alert = UIAlertController(title: error, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Reset Password", style:.default, handler: { action in
                        self.performSegue(withIdentifier: "logintoforgotpassword", sender: nil)
                    }))
                    self.present(alert, animated: true)
                }
                
                else{
                    let alert = UIAlertController(title: error, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
                
            }
            
            else{
                self.performSegue(withIdentifier: "fromlogintointro", sender: nil)
            }
        }
    }
    
    
    //MARK: TOUCHES BEGAN METHOD TO CLOSE KEYBOARD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
