//
//  MainTableCell.swift
//  Foody
//
//  Created by Dhitipong Thivakorakot on 18/3/2561 BE.
//  Copyright © 2561 CS3432. All rights reserved.
//

import UIKit

class MainTableCell: UITableViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentName: UILabel!
    @IBOutlet weak var contentTime: UILabel!
    @IBOutlet weak var contentStatus: UILabel!
    @IBOutlet weak var contentDistance: UILabel!
    @IBOutlet weak var contentDeliverRange: UILabel!
    @IBOutlet weak var contentIndex: UILabel!
    @IBOutlet weak var contentID: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
