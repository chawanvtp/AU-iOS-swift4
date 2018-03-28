//
//  MyTableCell.swift
//  Foody
//
//  Created by Dhitipong Thivakorakot on 20/3/2561 BE.
//  Copyright © 2561 CS3432. All rights reserved.
//

import UIKit
import Firebase
//import FBSDKLoginKit

class MyTableCell: UITableViewCell {

    @IBOutlet weak var userContentImage: UIImageView!
    @IBOutlet weak var userContentName: UILabel!
    @IBOutlet weak var userContentDeliverTime: UILabel!
    @IBOutlet weak var userContentDeliverRange: UILabel!
    @IBOutlet weak var userContentStatusBtn: UIButton!
    @IBOutlet weak var userContentID: UITextField!
    
    lazy var ref: DatabaseReference = Database.database().reference()
    
    @IBAction func userContentStatusBtnClicked(_ sender: Any) {
        //print(self.userContentStatusBtn.titleLabel!)
        var status = self.userContentStatusBtn.currentTitle
        
        if status == "Open" {
            status = "Closed"
            self.userContentStatusBtn.setTitle(status, for: .normal)
            self.userContentStatusBtn.setTitleColor(UIColor.red, for: .normal)
            
            //print(status)
        }else{
            status = "Open"
            self.userContentStatusBtn.setTitle(status, for: .normal)
            self.userContentStatusBtn.setTitleColor(UIColor.blue, for: .normal)
            //print(status)
            
        }
        
        
        
        ref.child("contents/\(self.userContentID.text as! String)/status").setValue(status)
       
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
