//
//  nomineeTableViewCell.swift
//  CS470Voting
//
//  Created by student on 4/17/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class nomineeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nomineeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func useNominee(_ nominee: String ) {
        /*if let aImage = artist.getImage()  {
         cellImage.image = aImage
         }*/
        
        
        nomineeName.text = nominee
        
        
    }
    
}
