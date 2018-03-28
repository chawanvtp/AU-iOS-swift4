//
//  ContentViewController.swift
//  Foody
//
//  Created by Dhitipong Thivakorakot on 21/3/2561 BE.
//  Copyright © 2561 CS3432. All rights reserved.
//

import UIKit
import FirebaseStorage

class ContentViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var contentViewImg: UIImageView!
    @IBOutlet weak var contentViewDetail: UILabel!
    @IBOutlet weak var contentViewName: UILabel!
    @IBOutlet weak var contentViewDeliverTime: UILabel!
    @IBOutlet weak var contentViewDeliverRange: UILabel!
    var currentContent: ContentModel!
    lazy var storageRef: StorageReference = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let content = currentContent {
            
             contentViewName.text = content.name
             contentViewDeliverTime.text = content.deliverTime
             contentViewDeliverRange.text = content.deliverRange
            
            // Reference to an image file in Firebase Storage
            let imageRef = storageRef.child(content.imageURL[0])
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    // Uh-oh, an error occurred!
                    print("ERROR XXX : \(error)")
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    self.contentViewImg.image = image
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
