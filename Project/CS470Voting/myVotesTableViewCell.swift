//
//  myVotesTableViewCell.swift
//  CS470Voting
//
//  Created by student on 5/9/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class myVotesTableViewCell: UITableViewCell {

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
    
    func setValues(_nominee: String, _category: String) {
        nominee.text = _nominee
        category.text = _category
    }

}
