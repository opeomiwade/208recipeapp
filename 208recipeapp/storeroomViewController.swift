//
//  storeroomViewController.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 08/03/2022.
//

import UIKit
import Firebase
import FirebaseAuth

var recipeSuggestions : [[String : String]] = [] // recipe suggestions list based on users ingredients.
class storeroomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: VARIABLES AND OUTLETS
    var storeroomItems : [String] = []
    var itemQuantity : [String] = []
    var current = ""
    var searchBarFilteredData : [String] = []
    @IBOutlet weak var myTable: UITableView!


    @IBAction func addbutton(_ sender: Any) {
        let alert = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type in the name of the item"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type in the quantity of the item"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            let itemName = alert.textFields![0].text
            let itemQuantity = alert.textFields![1].text
            self.storeroomItems.append(itemName!.lowercased())
            self.itemQuantity.append(itemQuantity!.lowercased())
            self.myTable.reloadData()
            UserDefaults.standard.set(self.storeroomItems,forKey: self.current + "storeroomItems")
            self.storeroomItems = UserDefaults.standard.object(forKey: self.current + "storeroomItems") as! [String]
            UserDefaults.standard.set(self.itemQuantity,forKey: self.current + "quantity")
            self.itemQuantity = UserDefaults.standard.object(forKey: self.current + "quantity") as! [String]
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        current = (Auth.auth().currentUser?.email)! //get currentuser email from firebase database.
        if let itemslist = UserDefaults.standard.object(forKey: current + "storeroomItems"){//retrieve current users itemlist from user defaults using users email.
            storeroomItems = itemslist as! [String]
            print(storeroomItems)
        }

        if let quantitylist = UserDefaults.standard.object(forKey: current + "quantity"){//retrieve current users itemquantity from user defaults using users email.
            itemQuantity = quantitylist as! [String]
            print(itemQuantity)
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: VIEWDIDLOAD()
    override func viewDidAppear(_ animated: Bool) {
        checkForRecipes()
        myTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Items"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeroomItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        cell.textLabel?.text = storeroomItems[indexPath.row]
        cell.detailTextLabel?.text = "Quantity: " + String(itemQuantity[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            storeroomItems.remove(at: indexPath.row)
            itemQuantity.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        //set userdefaults.
        UserDefaults.standard.set(storeroomItems,forKey: current + "storeroomItems")
        UserDefaults.standard.set(itemQuantity,forKey:  current + "quantity")
    }
    
    //MARK: MY METHODS
    //gives user recipes suggestions based on the ingredients in the storeroom.
    func checkForRecipes(){
        var found : Bool = false
        for arecipe in recipeListForSuggestionsClass{
            let ingredients = arecipe["Ingredients"]?.components(separatedBy: ",")
            let ingredientsSet = NSSet(array: ingredients ?? [])
            
            let storeroomItemsSet = NSSet(array: storeroomItems)
            found = ingredientsSet.isSubset(of: storeroomItemsSet as! Set<AnyHashable>)
            print(found)
            if(found == true && !(recipeSuggestions.contains(arecipe)) && !(arecipe.isEmpty)){
                recipeSuggestions.append(arecipe)
            }
            
            else if(found == false && recipeSuggestions.contains(arecipe)){
                let index = recipeSuggestions.firstIndex(of: arecipe)
                recipeSuggestions.remove(at: index!)
            }
        }
        print(recipeSuggestions)
    }
}
