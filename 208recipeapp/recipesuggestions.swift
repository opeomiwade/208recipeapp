//
//  recipesuggestions.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 31/03/2022.
//

import UIKit

class recipesuggestions: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: OUTLETS AND VARIABLES
    var current = 0
    @IBOutlet weak var myTable: UITableView!
    
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: VIEWDIDAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        myTable.reloadData()
        previousViewController = "suggestions"
    }
    
    
    //MARK: TABLE VIEW METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Suggestions"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! suggestionsTableViewCell
        cell.title.text = recipeSuggestions[indexPath.row]["name"]
        cell.subtitle.text = (recipeSuggestions[indexPath.row]["Calories"] ?? "") + " calories"
        cell.imageview.load(url: URL(string: recipeSuggestions[indexPath.row]["ImageUrl"] ?? "")! )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        current = indexPath.row
        performSegue(withIdentifier: "suggestionstodetail", sender: nil)
    }
    
    //MARK: SEGUE METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "suggestionstodetail"){
            let ViewController = segue.destination as! detailViewController
            ViewController.recipeInfo[0] = recipeSuggestions[current]["name"] ?? ""
            ViewController.recipeInfo[1] = recipeSuggestions[current]["Ingredients"] ?? ""
            ViewController.recipeInfo[2] = recipeSuggestions[current]["Instructions"] ?? ""
            ViewController.image = setImage(imageURL: recipeSuggestions[current]["ImageUrl"] ?? "")
        }
    }
    

    //MARK: SETIMAGE METHOD
    func setImage(imageURL : String) -> UIImage{ // method to get images from url but not used for tableview.
        var imageData : Data!
        var image : UIImage? = nil
        let url = URL(string: imageURL)!
            if let imagedata = try? Data(contentsOf: url){
                    imageData = imagedata
            }
            image = UIImage(data: imageData)!
        return image!
    }
    
    @IBAction func unwindTorecipesuggestions(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
        

}
