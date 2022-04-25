//
//  detailViewController.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 06/03/2022.
//

import UIKit

var previousViewController = ""
class detailViewController: UIViewController {
    
    
    var image : UIImage!
    var recipeInfo = ["","","","",""]
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var instructions: UITextView!
   
    
    @IBAction func buttonpressed(_ sender: Any) {
        if(previousViewController == "fav"){
            performSegue(withIdentifier: "returntofavorites", sender: nil)
        }
        
        else if(previousViewController == "veggie"){
            performSegue(withIdentifier: "returntoveggielist", sender: nil)
        }
        
        else if(previousViewController == "nonveg"){
            performSegue(withIdentifier: "returntorecipelist", sender: nil)
        }
        
        else if(previousViewController == "suggestions"){
            performSegue(withIdentifier: "returntosuggestions", sender: nil)
        }
    }
    
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = recipeInfo[0]
        ingredients.text = "Ingredients - " + recipeInfo[1]
        instructions.text = "Instructions - " + recipeInfo[2]
        imageview.image = image
        // Do any additional setup after loading the view.
    }
    

   

}
