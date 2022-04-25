//
//  initialViewController.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 21/02/2022.
//

import UIKit

class initialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToinitial( _ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
    }
    
     
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
