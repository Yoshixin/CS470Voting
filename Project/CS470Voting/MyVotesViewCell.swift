//
//  MyVotesViewCell.swift
//  CS470Voting
//
//  Created by student on 5/8/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class MyVotesViewCell: UITableViewCell {
    
    @IBOutlet weak var nominee: UILabel!
    @IBOutlet weak var category: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func useNominee(_nominee: String) {
        nominee.text = _nominee
    }
    
    func useCategory(_category: String) {
        category.text = _category
    }

}
