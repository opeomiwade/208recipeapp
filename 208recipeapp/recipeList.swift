//
//  recipeList.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 03/03/2022.
//

import UIKit
import Firebase
import FirebaseAuth

var favorites : [[String : String]] = []
var recipeListForSuggestionsClass : [[String : String]] = []

class recipeList: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
// MARK: VARIABLES AND OUTLETS
    var recipe : recipes? = nil
    var recipeOrigins : [String] = []
    var current = 0
    var origin = ""
    var recipeArr = [[String : String]()]
    var currentUser = ""
    var searchBarFlteredData = [[String : String]()]
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "fromnonvegtoform", sender: nil)
    }
    
    
//MARK: VIEWDIDLOAD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
        fillRecipeArray()
        recipeListForSuggestionsClass = recipeArr // array used in recipe suggestion class.
        currentUser = (Auth.auth().currentUser?.email)!
        if let recipe = UserDefaults.standard.object(forKey: "recipeArr"){//retrieval of persistent storage for recipes added by user
            searchBarFlteredData = recipe as! [[String : String]]
        }
        
        else{
            searchBarFlteredData = recipeArr
        }
        
        if let origins = UserDefaults.standard.object(forKey: "recipeOrigins"){
            recipeOrigins = origins as! [String]
        }
        myTable.reloadData()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        previousViewController = "nonveg"
        myTable.reloadData()
    }
    

    // MARK: - TABLE VIEW DATA SOURCE

    func numberOfSections(in tableView: UITableView) -> Int {
        return recipeOrigins.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipeOrigins[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let origin = recipeOrigins[section]
        return(rows(origin: origin))
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! recipeTableViewCell
        //print(recipeOrigins)
        let origin = recipeOrigins[indexPath.section]
        //print(origin)
        let recipes = recipesWithSameOrigin(origin: origin)
        let current = recipes[indexPath.row]
        cell.title?.text = current["name"]
        cell.subtitle?.text = (current["Calories"] ?? " ") + " calories"
        cell.imageview.load(url: URL(string : current["ImageUrl"] ?? "")!)
        cell.accessoryType = .disclosureIndicator
        if(favorites.contains(current)){
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        current = indexPath.row
        origin = recipeOrigins[indexPath.section]
        performSegue(withIdentifier: "fromnonvegtodetail", sender: nil)
    }
      
    
    //MARK: SEGUE METHOD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromnonvegtodetail"){
            let ViewController = segue.destination as! detailViewController
            let recipedetails = recipesWithSameOrigin(origin: origin)
            let currentrecipedetails = recipedetails[current]
            ViewController.recipeInfo[0] = currentrecipedetails["name"] ?? " "
            ViewController.recipeInfo[1] = currentrecipedetails["Ingredients"] ?? " "
            ViewController.recipeInfo[2] = currentrecipedetails["Instructions"] ?? " "
            ViewController.image = setImage(imageURL: currentrecipedetails["ImageUrl"] ?? " " )
        }
        
        if segue.identifier == "fromnonvegtoform" {
            let ViewController = segue.destination as! RecipeForm
            ViewController.recipeArr = searchBarFlteredData
            ViewController.recipeOrigins = recipeOrigins
        }
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favouriteAction = UIContextualAction(style: .normal, title: "Favourite"){(action, view, completionHandler) in
            completionHandler(true)
        }
        let origin = recipeOrigins[indexPath.section]
        let recipes = recipesWithSameOrigin(origin: origin)
        let current = recipes[indexPath.row]
        
        if(!(favorites.contains(current))){
            favorites.append(current)
        }
        
        else{// if the user swipes again on a cell that is already marked as favorite,remove this cell from favorites
            favorites = favorites.filter{$0 != current}
        }
        UserDefaults.standard.set(favorites,forKey: currentUser)
        favorites = UserDefaults.standard.object(forKey: currentUser) as! [[String : String]]
        myTable.reloadData() //reload table data so checkmark can be added to appropriate cell
        favouriteAction.backgroundColor = .systemBlue
        //print(favorites)
        return UISwipeActionsConfiguration(actions: [favouriteAction])
    }
    
//MARK: Search BAR CONFIG
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text == ""{
           searchBarFlteredData = recipeArr
        }

        else{
            searchBarFlteredData = []
            var i = 0
            for recipe in recipeArr{
                let recipename = recipe["name"] ?? " "
                if recipename.lowercased().contains((searchbar.text?.lowercased())!) && !(searchBarFlteredData.contains(recipe)){
                    searchBarFlteredData.insert(recipe, at: i)
                    i += 1
                }
            }
        }
        myTable.reloadData()
    }
    
    
// MARK: MY METHODS
    
    private func parseJSON(){
        guard let path  = Bundle.main.path(forResource: "data", ofType: "json")
        else{
            return
        }
        let url = URL(fileURLWithPath: path)
        do{
            let jsonData = try Data(contentsOf: url)
            let recipeList = try JSONDecoder().decode(recipes.self,from: jsonData)
            self.recipe = recipeList
            DispatchQueue.main.async {
                self.updateTheTable()
            }
            var i = 0
            for arecipe in recipeList.recipes{
                if(!(recipeOrigins.contains(arecipe.Origin))){
                    recipeOrigins.insert(arecipe.Origin, at: i)
                    i += 1
                }
            }
        }
        catch{
            print("Error : \(error)")
        }
    }
    
    func updateTheTable(){
        myTable.reloadData()
    }
    
    func rows(origin : String) -> Int{
        var rowCounter = 0
        for arecipe in searchBarFlteredData{
            if(arecipe["Origin"] == origin && (arecipe["Variation"] == "Non-veggie" || arecipe["Variation"] == "desert")){
                rowCounter += 1
            }
        }
        return rowCounter
    }
    
    func recipesWithSameOrigin(origin : String) -> [[String : String]]{
        var i = 0
        var array = [[String : String]()]
        for recipe in searchBarFlteredData{
            if(recipe["Origin"] ?? "" == origin && (recipe["Variation"] ?? "" == "Non-veggie" || recipe["Variation"] ?? "" == "desert")){
                array.insert(recipe, at: i)
                i += 1
            }
        }
        return array
    }
    
    
    func setImage(imageURL : String) -> UIImage{ // method to get images from url but not used for tabelview.
        var imageData : Data!
        var image : UIImage? = nil
        let url = URL(string: imageURL)!
            if let imagedata = try? Data(contentsOf: url){
                    imageData = imagedata
            }
            image = UIImage(data: imageData)!
        return image!
    }
    
    func fillRecipeArray(){
        var counter = 0
        for arecipe in recipe!.recipes{
            recipeArr.insert(["name" : arecipe.name ,"Ingredients" : arecipe.Ingredients,"Instructions" : arecipe.Instructions,"Origin" : arecipe.Origin,"Variation" : arecipe.Variation,"Calories" : arecipe.Calories,"ImageUrl" : (arecipe.ImageUrl!).absoluteString],at: counter)
            counter += 1
        }
    }
    
    @IBAction func unwindToRecipeList(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}

extension UIImageView { // for the tableview to prevent lagging while scrolling through the recipes
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
