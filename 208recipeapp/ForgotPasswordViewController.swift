//
//  ForgotPasswordViewController.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 16/03/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailtextfiedl: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Auth.auth().currentUser?.email)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func confrimbutton(_ sender: Any) {
        let user = Auth.auth().currentUser?.email
        print(user!)
        Auth.auth().sendPasswordReset(withEmail: emailtextfiedl.text!)
        let alert = UIAlertController(title: "Password reset email has been sent", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: {  action in
            self.performSegue(withIdentifier:"retunrtoinitial", sender: nil)
        }))
        present(alert, animated: true)
        
    }
    

    
    

}
