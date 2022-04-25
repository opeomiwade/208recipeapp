//
//  SignupViewController.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 15/03/2022.
//

import UIKit
import FirebaseAuth
import Firebase

class SignupViewController: UIViewController {
    
    //MARK: IBOUTLETS
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var signupbutton: UIButton!
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordtext.autocorrectionType = .no
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: IBACTION METHOD
    @IBAction func buttonpressed(_ sender: Any) {
        //Validate fields
        validateuserInput()
        
        // remove whitespaces and newliones from password and email.
        let email = emailtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //MARK: USER AUTHENTICATION AND VALIDATION
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            //Check for errors
            if error != nil{
                self.label.text = "Error with user creation"
                print(error!)
            }
            
            else{
                //user created successfully
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["email": email, "password" : password,"userid" : result!.user.uid]) { (error) in
                    if error != nil{
                        print("error")
                    }
                }
                let alert = UIAlertController(title:"Account has been created", message: "You can log in", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert in
                    //segue to intial view of appplication
                    self.performSegue(withIdentifier: "returntoinitial", sender: nil)
                }))
                self.present(alert, animated: true)
            }
        }
        //close keyboard after signup button is clicked
        emailtext.resignFirstResponder()
        passwordtext.resignFirstResponder()
    }
    
    
    //MARK: METHOD TO ENSURE USER INPUT IS VALID
    func validateuserInput(){
        //check user has provided necessary information by removing whitepsaces and newlines from text field and checking if it is empty
        if(emailtext.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordtext.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "A field or all fields are empty", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            //print("both empty")
        }
        
        //check if password is secure enough for account
        let trimmedpassword = passwordtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(trimmedpassword) == false{
            let alert = UIAlertController(title: "Password isnt secure", message: "Make sure password is at least 8 characters,contains an alpahbet and a special character", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            //print("just pass")
        }
        
        //ensure email is in correct format e.g ope@emailaddress.com or io@emailaddress.co.uk
        let trimmedEmail = emailtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(isEmailValid(trimmedEmail) == false){
            let alert = UIAlertController(title: "Email is incorrect", message: "Make sure your email is in the correct format", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            //print("email invalid")
        }
        
    }
    
    //MARK: VALIDATE USER PASSWORD
    func isPasswordValid(_ password : String) -> Bool{
        /*
         Password validation criteria
         1 - Password length is 8.
         2 - One Alphabet in Password.
         3 - One Special Character in Password.
         
         
         Regex explained
         ^                                - Start Anchor.
         (?=.*[a-z])                 -Ensure string has one character.
         (?=.[$@$#!%?&])      -Ensure string has one special character.
         {8,}                            -Ensure password length is 8.
         $                                -End Anchor.
         */
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //MARK: VALIDATE USER EMAIL
    func isEmailValid(_ email : String) -> Bool
    {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        return emailTest.evaluate(with: email)
    }
    
    
    //hide keyboard on screen click
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
