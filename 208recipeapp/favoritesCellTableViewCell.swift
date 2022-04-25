//
//  favoritesCellTableViewCell.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 20/03/2022.
//

import UIKit

class favoritesCellTableViewCell: UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
