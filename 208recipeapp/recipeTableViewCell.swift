//
//  recipeTableViewCell.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 04/03/2022.
//

import UIKit

class recipeTableViewCell: UITableViewCell {

    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var imageview2: UIImageView!
    @IBOutlet weak var subtitle2: UILabel!
    @IBOutlet weak var title2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
