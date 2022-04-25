//
//  datamodel.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 28/02/2022.
//

import Foundation
struct recipe : Decodable{
    let name : String
    let Ingredients : String
    let Instructions : String
    let Origin : String
    let Variation : String
    let Calories : String
    let ImageUrl : URL?
}

struct recipes : Decodable{
    let recipes : [recipe]
}
