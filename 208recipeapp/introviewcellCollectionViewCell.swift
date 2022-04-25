//
//  introviewcellCollectionViewCell.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 21/02/2022.
//

import UIKit

class introviewcellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var suntitle: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func setup(_ slide : introview){
        suntitle.text = slide.description
        title.text = slide .title
        imageview.image = slide.image
    }
}
