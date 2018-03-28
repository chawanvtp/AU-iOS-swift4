//
//  AddContentViewController.swift
//  Foody
//
//  Created by Dhitipong Thivakorakot on 27/3/2561 BE.
//  Copyright © 2561 CS3432. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import AssetsLibrary

class AddContentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    lazy var ref: DatabaseReference = Database.database().reference()
    lazy var storageRef = Storage.storage().reference()
    
    var userToken: UserModel!
    // --------------------
    var imageURLs: [String] = []
    var imagePaths: [String] = []
    
    let imagePicker = UIImagePickerController()
    // content's - Images
    @IBOutlet weak var img0: UIImageView!
    
    // ADD content - Images
    @IBOutlet weak var imgAddBtn0: UIButton!
    @IBOutlet weak var imgAddBtn1: UIButton!
    @IBOutlet weak var imgAddBtn2: UIButton!
    
    // ADD content - Text Fields
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var addDeliverTime: UITextField!
    @IBOutlet weak var addDeliverRange: UITextField!
    @IBOutlet weak var addDetail: UITextField!
    @IBOutlet weak var addContact: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if (self.userToken) != nil {
            print(self.userToken.name)
            
            
        }
        // Do any additional setup after loading the view.
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
    @IBAction func confirmBtnClicked(_ sender: Any) {
      
            
            let name = self.addName.text!
            let time = self.addDeliverTime.text!
            let range = self.addDeliverRange.text!
            let detail = self.addDetail.text!
            let contact = self.addContact.text!
        
            if(name != "" && time != "" && range != "" && detail != "" && contact != "" && imagePaths.count >= 1){
                let key = self.ref.child("contents").childByAutoId().key
                let content = [
                    "deliverRange":  range,
                    "deliverTime":  time,
                    "imageURL":  imagePaths,
                    "location":  "x00:00 y00:00",
                    "name":  name,
                    "owner":  self.userToken!.name,
                    "ownerID":  self.userToken!.id,
                    "status":  "Closed",
                    "contact": contact,
                    "detail": detail,
                    "menu": ["none","none"]
                    ] as [String : Any]
                self.userToken?.stores.append(key)
                self.ref.child("users/\(self.userToken!.id)/stores").setValue(self.userToken?.stores)
                
                self.ref.child("contents/\(key)").setValue(content)
                //switchMode()
                var count: Int = 0
                for each in imagePaths {
                    // File located on disk
                    let localFile = URL(string: each)!
                    
                    // Create a reference to the file you want to upload
                    let userRef = storageRef.child("\(userToken.id)/images/\(key)/img\(count).jpg")
                    
                    // Upload the file to the path "images/rivers.jpg"
                    let uploadTask = userRef.putFile(from: localFile, metadata: nil) { metadata, error in
                        if error != nil {
                            // Uh-oh, an error occurred!
                        } else {
                            // Metadata contains file metadata such as size, content-type, and download URL.
                            let path: String = metadata!.path!
                            print("======= > \(path)")
                            self.imageURLs.append(path)
                            
                            let updateContent = [
                                "deliverRange":  range,
                                "deliverTime":  time,
                                "imageURL":  self.imageURLs,
                                "location":  "x00:00 y00:00",
                                "name":  name,
                                "owner":  self.userToken!.name,
                                "ownerID":  self.userToken!.id,
                                "status":  "Closed",
                                "contact": contact,
                                "detail": detail,
                                "menu": ["none","none"]
                                ] as [String : Any]
                            self.ref.child("contents/\(key)").setValue(updateContent)
 
                        }
                    }
                    count += 1
                }
                
                /**
                if imageURLs.count >= 1 {
                    print("KKKKKK")
                    print(imageURLs[0])
                }
                */
                
            }
    }
    
    
    @IBAction func addFirstImg(_ sender: Any) {
        //var imagesDirectoryPath:String!
        //var images:[UIImage]!
        //var titles:[String]!
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImageURL = info[UIImagePickerControllerImageURL] as! NSURL!
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let path: String = chosenImageURL!.absoluteString!
        imagePaths.append(path)
        print(chosenImageURL!)
        img0.image = chosenImage
        dismiss(animated: true, completion: nil)
        print("------------------")
        print(imagePaths.count)
        print(imagePaths[0])
         print("------------------")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        return
    }
    
    
}
