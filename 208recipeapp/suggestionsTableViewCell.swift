//
//  suggestionsTableViewCell.swift
//  208recipeapp
//
//  Created by Ope Omiwade on 25/04/2022.
//

import UIKit

class suggestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
