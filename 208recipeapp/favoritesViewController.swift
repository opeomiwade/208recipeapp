//
//  favoritesViewController.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 20/03/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class favoritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var favoritesArr = [[String : String]()]
    var current = 0
    var currentUser = ""
    var searchBarFlteredData = [[String : String]()]
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var myTable: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = (Auth.auth().currentUser?.email)!
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTable.reloadData() // reload tableview data when viewcontroller appears
    }
    
    
    override func viewWillAppear(_ animated: Bool) {// assign new data for the table view before viewcontroller is loaded.
        favoritesArr = favorites
        searchBarFlteredData = favoritesArr
        previousViewController = "fav"
    }
       
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorites"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBarFlteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! favoritesCellTableViewCell
        cell.title.text = searchBarFlteredData[indexPath.row]["name"]
        cell.subtitle.text = (searchBarFlteredData[indexPath.row]["Calories"] ?? "") + " calories"
        cell.imageview.load(url: URL(string : searchBarFlteredData[indexPath.row]["ImageUrl"] ?? "")!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        current = indexPath.row
        performSegue(withIdentifier: "favoritestodetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            favorites.remove(at: indexPath.row) // delete from global data structure
            searchBarFlteredData.remove(at: indexPath.row)// delete from class data structure
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        UserDefaults.standard.set(favorites,forKey: currentUser)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "favoritestodetail"){
            let ViewController = segue.destination as! detailViewController
            ViewController.recipeInfo[0] = searchBarFlteredData[current]["name"] ?? ""
            ViewController.recipeInfo[1] = searchBarFlteredData[current]["Ingredients"] ?? ""
            ViewController.recipeInfo[2] = searchBarFlteredData[current]["Instructions"] ?? ""
            ViewController.image = setImage(imageURL: searchBarFlteredData[current]["ImageUrl"] ?? "")
        }
    }
    

//MARK: SETIMAGE METHOD
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
    

//MARK: SEARCH BAR CONFIG
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text == ""{
           searchBarFlteredData = favoritesArr
        }

        else{
            searchBarFlteredData = []
            var i = 0
            for recipe in favoritesArr{
                let recipename = recipe["name"] ?? " "
                if recipename.lowercased().contains((searchbar.text?.lowercased())!) && !(searchBarFlteredData.contains(recipe)){
                    searchBarFlteredData.insert(recipe, at: i)
                    i += 1
                }
            }
        }
        myTable.reloadData()
    }

    @IBAction func unwindTofavorites(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }

   

}
