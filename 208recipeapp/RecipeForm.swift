//
//  RecipeForm.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 25/03/2022.
//

import UIKit

class RecipeForm: UIViewController,UITextFieldDelegate,UITextViewDelegate{
    
    //MARK: OUTLETS AND VARIABLES
    var recipeArr = [[String : String]()]
    var recipeOrigins : [String] = []
    var imageUrl = " "
    var cancelClicked = false
    @IBOutlet weak var recipeImage: UIImageView!
        
    @IBOutlet weak var recipeName: UITextField!
    
    @IBOutlet weak var recipeInstructions: UITextView!
    
    @IBOutlet weak var recipeIngredients: UITextView!

    @IBOutlet weak var recipeOrigin: UITextField!
    
    @IBOutlet weak var recipeCalories: UITextField!
    
    @IBOutlet weak var recipeType: UITextField!
    
    //MARK: ACTIONS
    @IBAction func importImagebutton(_ sender: Any) {
        let image = UIImagePickerController()
        image.sourceType = .photoLibrary
        image.delegate = self
        image.allowsEditing = true
        present(image, animated: true)
    }
    
    @IBAction func cancelbutton(_ sender: Any) {
        if(previousViewController == "veggie"){
            cancelClicked = true
            performSegue(withIdentifier: "returntoVeggie", sender: nil)
        }
      
        if previousViewController == "nonveg"{
            cancelClicked = true
            performSegue(withIdentifier: "returntononveg", sender: nil)
        }
    }
    
    
    
    @IBAction func confrimbutton(_ sender: Any) {
        if(validateInputs() == false){ // if input is not valid keep checking until it is
            _ = validateInputs()
        }
        
        else{
            recipeArr.append(["name" : recipeName.text!,"Ingredients" : recipeIngredients.text!,"Instructions" : recipeIngredients.text!.lowercased(), "Origin" : recipeOrigin.text!,"Variation" : recipeType.text!, "Calories" : recipeCalories.text!,"ImageUrl" : imageUrl])
            recipeOrigins.append(recipeOrigin.text!)
            let alert = UIAlertController(title: "Recipe has been added", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
            if(previousViewController == "veggie"){
                UserDefaults.standard.set(recipeArr,forKey: "recipeArr")
                recipeArr = UserDefaults.standard.object(forKey: "recipeArr") as! [[String : String]]
                UserDefaults.standard.set(recipeOrigins,forKey: "recipeOrigins")
                recipeOrigins = UserDefaults.standard.object(forKey: "recipeOrigins") as! [String]
                performSegue(withIdentifier: "returntoVeggie", sender: nil)
            }
            
            if(previousViewController == "nonveg"){
                UserDefaults.standard.set(recipeArr,forKey: "recipeArr")
                recipeArr = UserDefaults.standard.object(forKey: "recipeArr") as! [[String : String]]
                UserDefaults.standard.set(recipeOrigins,forKey: "recipeOrigins")
                recipeOrigins = UserDefaults.standard.object(forKey: "recipeOrigins") as! [String]
                performSegue(withIdentifier: "returntononveg", sender: nil)
            }
        }
    }
    
   
    //MARK: VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        cancelClicked = false //reset boolean value hwne from pops up
    }
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        if previousViewController == "nonveg"{
            recipeType.placeholder = "Dish type i.e is it Non-veggie or desert."
        }
        
        else if previousViewController == "veggie"{
            recipeType.placeholder = "Dish type i.e is it veggie or desert."
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: SEGUE METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "returntoVeggie") && cancelClicked == false{
            let ViewController = segue.destination as! veggierecipelist
            ViewController.searchBarFlteredData = recipeArr
            recipeListForSuggestionsClass = recipeArr
            if !(ViewController.recipeOrigins.contains(recipeOrigin.text!)){
                ViewController.recipeOrigins = recipeOrigins
            }
        }
        
        if segue.identifier == "returntononveg" && cancelClicked == false{
            let ViewController = segue.destination as! recipeList
            ViewController.searchBarFlteredData = recipeArr
            recipeListForSuggestionsClass = recipeArr
            if !(ViewController.recipeOrigins.contains(recipeOrigin.text!)){
                ViewController.recipeOrigins = recipeOrigins
            }
        }
    }
    
    
    //MARK: METHOD TO VALIDATE USER INPUTS
    func validateInputs() -> Bool{
        var proceed = true;
        if(recipeName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || recipeType.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || recipeCalories.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || recipeOrigin.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || recipeInstructions.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || recipeIngredients.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || recipeImage.image == nil){
            let alert = UIAlertController(title: "A field,all fields are empty or you are yet to import an image ", message: "Please fill in all fields or import image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            proceed = false
        }
        return proceed
    }
}

//MARK: METHODS TO ALLOW USER TO IMPORT IMAGES FROM CAMERA ROLL
extension RecipeForm : UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            recipeImage.image = image
        }
        if let url = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerImageURL")] as? URL{
            imageUrl = url.absoluteString
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
    
    //hides keyboard on screen tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide skeyboard when return key is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recipeName.resignFirstResponder()
        recipeOrigin.resignFirstResponder()
        recipeType.resignFirstResponder()
        recipeCalories.resignFirstResponder()
        return true
    }
    
     
}
