//
//  categoriesTableViewCell.swift
//  CS470Voting
//
//  Created by student on 4/17/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class categoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func useCategory(_ category: String ) {
        /*if let aImage = artist.getImage()  {
         cellImage.image = aImage
         }*/
        
        
        categoryName.text = category
        
       
    }

}
