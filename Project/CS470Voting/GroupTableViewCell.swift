//
//  GroupTableViewCell.swift
//  CS470Voting
//
//  Created by student on 5/3/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func useGroup(_ group: String ) {
        groupName.text = group
    }
    
}
