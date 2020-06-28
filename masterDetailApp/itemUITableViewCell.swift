//
//  itemUITableViewCell.swift
//  Master Detailed App Version 02
//
//  Created by Wagee Ishani on 5/21/19.
//  Copyright © 2019 Wagee Ishani. All rights reserved.
//

import UIKit

class itemUITableViewCell: UITableViewCell{
    
    
    //To be shown in table - UI items
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //this isn't really need, I think
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
