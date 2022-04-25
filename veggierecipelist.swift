//
//  veggierecipelist.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 05/03/2022.
//

import UIKit
import Firebase
import FirebaseAuth

//var veggieFavorites = [[String : String]()]
class veggierecipelist: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    // MARK: VARIABLES , OUTLETS AND IBACTIONS
    var recipe : recipes? = nil
    var current = 0
    var origin = ""
    var recipeOrigins : [String] = []
    var recipeArr = [[String : String]()]
    var searchBarFlteredData : [[String : String]] = []
    var currentUser = " "
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "fromVeggietoform", sender: nil)
    }

//MARK: VIEWDIDLLOAD()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = (Auth.auth().currentUser?.email)!
        print(currentUser)
        parseJSON()
        fillRecipeArray()
        if let recipe = UserDefaults.standard.object(forKey: "recipeArr"){//retrieval of persistent storage for recipes added by user
            searchBarFlteredData = recipe as! [[String : String]]
        }
        
        else{
            searchBarFlteredData = recipeArr
        }
        
        if let origins = UserDefaults.standard.object(forKey: "recipeOrigins"){
            recipeOrigins = origins as! [String]
        }
        
        if let favorite = UserDefaults.standard.object(forKey: currentUser){//retrieval of persistent storage for the current users' favorite recipes
            favorites = favorite as! [[String : String]]
        }
    // Do any additional setup after loading the view.
    }
    
//MARK: VIEWDIDAPPEAR()
    override func viewDidAppear(_ animated: Bool) {
        previousViewController = "veggie"
        myTable.reloadData()
    }
    
    
    // MARK: - Table view data source

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
        let origin = recipeOrigins[indexPath.section]
        let recipes = recipesWithSameOrigin(origin: origin)
        let current = recipes[indexPath.row]
        cell.title2?.text = current["name"]
        cell.subtitle2?.text = (current["Calories"] ?? " ") + " calories"
        cell.imageview2.load(url: URL(string: current["ImageUrl"] ?? " ")!)
        cell.accessoryType = .disclosureIndicator
        if(favorites .contains(current)){
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        current = indexPath.row
        origin = recipeOrigins[indexPath.section]
        performSegue(withIdentifier: "fromvegtodetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromvegtodetail"{
            let ViewController = segue.destination as! detailViewController
            let recipedetails = recipesWithSameOrigin(origin: origin)
            let currentrecipedetails = recipedetails[current]
            ViewController.recipeInfo[0] = currentrecipedetails["name"] ?? " "
            ViewController.recipeInfo[1] = currentrecipedetails["Ingredients"] ?? " "
            ViewController.recipeInfo[2] = currentrecipedetails["Instructions"] ?? " "
            ViewController.image = setImage(imageURL: currentrecipedetails["ImageUrl"] ?? "" )}
        
        if(segue.identifier == "fromVeggietoform"){
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
        
        else{
           favorites = favorites.filter{$0 != current}
        }
        UserDefaults.standard.set(favorites,forKey: currentUser)
        favorites = UserDefaults.standard.object(forKey: currentUser) as! [[String : String]]
        myTable.reloadData() //reload table data so checkmark can be added to appropriate cell
        favouriteAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [favouriteAction])
    }
    
//MARK: SEARCH BAR CONFIG
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
            //recipeArr = searchBarFlteredData
            //print(recipeArr)
        }
        myTable.reloadData()
    }
    
    
    // MARK: MY Methods
    
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
            if(arecipe["Origin"] == origin && (arecipe["Variation"] == "veggie" || arecipe["Variation"] == "desert")){
                rowCounter += 1
            }
        }
        return rowCounter
    }
    
    func recipesWithSameOrigin(origin : String) -> [[String : String]]{
        var i = 0
        var array = [[String : String]()]
        for recipe in searchBarFlteredData{
            if(recipe["Origin"] ?? "" == origin && (recipe["Variation"] ?? "" == "veggie" || recipe["Variation"] ?? "" == "desert")){
                array.insert(recipe, at: i)
                i += 1
            }
        }
        return array
    }
    
    
    func setImage(imageURL : String) -> UIImage{
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
            recipeArr.insert(["name" : arecipe.name ,"Ingredients" : arecipe.Ingredients,"Instructions" : arecipe.Instructions,"Origin" : arecipe.Origin,"Variation" : arecipe.Variation,"Calories" : arecipe.Calories,"ImageUrl" : (arecipe.ImageUrl)!.absoluteString],at: counter)
            counter += 1
        }
    }
    

    @IBAction func unwindToveggierecipelist(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }

}
