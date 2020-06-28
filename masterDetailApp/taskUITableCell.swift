//
//  taskUITableCell.swift
//  Master Detailed App Version 02
//
//  Created by Wagee Ishani on 5/21/19.
//  Copyright © 2019 Wagee Ishani. All rights reserved.
//

import UIKit

class taskUITableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var taskProgress: CircularProgressView!
    @IBOutlet weak var taskProgressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func taskProgress (value: Float) {
        taskProgress.trackColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        taskProgress.progressColor = UIColor(red: 252.0/255.0, green: 141.0/255.0, blue: 0/255.0, alpha: 1.0)
        taskProgress.setProgressWithAnimation(duration: 1.0, value: value)
        taskProgressLabel.text = "\(Int(round(value * 100)))%"
    }
}
