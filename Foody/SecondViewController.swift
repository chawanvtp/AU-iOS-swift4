//
//  SecondViewController.swift
//  Foody
//
//  Created by Dhitipong Thivakorakot on 18/3/2561 BE.
//  Copyright © 2561 CS3432. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
//import FBSDKLoginKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userContents = [ContentModel]()
    

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoImage: UIImageView!
    
    
    // ADD content - Outlets
    @IBOutlet weak var addContentBtn: UIButton!
    @IBOutlet weak var addNameLbl: UILabel!
    @IBOutlet weak var addDeliverTimeLbl: UILabel!
    @IBOutlet weak var addDeliverRangeLbl: UILabel!
    @IBOutlet weak var addDeliverRangeKmLbl: UILabel!
    @IBOutlet weak var addDetailLbl: UILabel!
    @IBOutlet weak var addConfirmBtn: UIButton!
    
    // ADD content - Text Fields
    
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var addDeliverTime: UITextField!
    @IBOutlet weak var addDeliverRange: UITextField!
    @IBOutlet weak var addDetail: UITextField!
    
    
    lazy var storageRef: StorageReference = Storage.storage().reference()
    lazy var ref: DatabaseReference = Database.database().reference()
    var userToken: UserModel?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableCell") as! MyTableCell
    
        cell.userContentID.text = userContents[indexPath.row].id
            cell.userContentName.text = userContents[indexPath.row].name
        cell.userContentDeliverTime.text = "Open: " + userContents[indexPath.row].deliverTime
            cell.userContentDeliverRange.text = userContents[indexPath.row].deliverRange + " km"
        cell.userContentImage.image = UIImage(named: userContents[indexPath.row].imageURL[0])
        
        if userContents[indexPath.row].status == "Closed" {
          cell.userContentStatusBtn.setTitleColor(UIColor.red, for: .normal)
        }else{
        cell.userContentStatusBtn.setTitle(String(userContents[indexPath.row].status), for: .normal)
            cell.userContentStatusBtn.setTitleColor(UIColor.blue, for: .normal)
        }
        
        // Reference to an image file in Firebase Storage
        let imageRef = storageRef.child(userContents[indexPath.row].imageURL[0])
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
                print("ERROR XXX : \(error)")
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                cell.userContentImage.image = image
            }
        }
        
        
        return cell
    }
    
    
    // ===== LoginBtnClicked EVENTs =====
    @IBAction func loginBtnClicked(_ sender: Any) {
        let usernameLogin = self.usernameInput.text!
        
        // - Connecting to firebase using ... " Username (text field) "
        ref.child("users").child(usernameLogin).observeSingleEvent(of: .value, with:
            { (snapshot) in
                let value = snapshot.value! as? [String: Any]
                let username = snapshot.key
                let name = value!["name"] as! String
                let password = value!["password"] as! String
                
                // - Initialize User Token
                if(username == self.usernameInput.text && password == self.passwordInput.text){
                    let location = value!["location"] as! String
                    let stores = value!["stores"] as! [String]
                    self.userToken = UserModel(id: username, name: name, password: password, location: location, stores: stores)
                    self.loginBtn.isHidden = true
                    self.usernameInput.isHidden = true
                    self.passwordInput.isHidden = true
                    self.logoImage.isHidden = true
                }
                self.profileName.text = self.userToken?.name
                self.profileName.isHidden = false
                self.profileImage.isHidden = false
                self.addContentBtn.isHidden = false
                for storeKey in self.userToken!.stores {
                    self.ref.child("contents/"+String(storeKey)).observe(.value, with: { (snapshot) in
                    
                        let content = ContentModel(snapshot: snapshot)
                        if(self.updateContent(content: content!)) == false {
                            self.userContents.append(content!)
                        }
                        
                        self.tableView.reloadData()
                        
                    }, withCancel: { (Error) in
                        print(Error.localizedDescription)
                    })
                }
                        self.tableView.isHidden = false
        })
        { (error) in
            print("Account has NOT been registered. XXX")
            print(error.localizedDescription)
        }
        //print(self.userToken?.name)
 
       /**
        if let accessToken = FBSDKAccessToken.current() {
            print(accessToken.userID)
        }
 */
    }
    
    
    // ====== xxx =====
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        /** Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Foods"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        */
        // Do any additional setup after loading the view, typically from a nib.
       
        if let temp = self.userToken?.stores {
            logedIn()
            for storeKey in temp {
                
                ref.child("contents"+String(storeKey)).observe(DataEventType.childChanged, with: { (snapshot) in
                    let content = ContentModel(snapshot: snapshot)
                    if(self.updateContent(content: content!)) == false {
                        self.userContents.append(content!)
                    }
                    
                    self.tableView.reloadData()
                }, withCancel: { (Error) in
                    print(Error.localizedDescription)
                })
                
                ref.child("contents"+String(storeKey)).observe(DataEventType.childRemoved, with: { (snapshot) in
                    let content = ContentModel(snapshot: snapshot)
                    self.deleteContent(content: content!)
                    self.tableView.reloadData()
                }, withCancel: { (Error) in
                    print(Error.localizedDescription)
                })
                
                
            }
            
            self.tableView.reloadData()
        }
        
        
        
        
    }
    
    func logedIn(){
        usernameInput.isHidden = true
        passwordInput.isHidden = true
        loginBtn.isHidden = true
        profileName.text = self.userToken?.name
        profileName.isHidden = false
        profileImage.isHidden = false
        addContentBtn.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ---------------------------------------
    //
    
    // - TO Adjust -> mainTableCell's Height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    @IBAction func addContentBtnClicked(_ sender: Any) {
        //switchMode()
        self.performSegue(withIdentifier: "showAddContent", sender: self.userToken!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showAddContent"){
            //let selectedIndex = (sender as! Int)
            let nextController = segue.destination as! AddContentViewController
            
            // TO Set Variable "ContentModel" in - ContentViewController
            nextController.userToken = self.userToken!
            
        }
    }
    
    
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        switchMode()
    }
    
    
    func switchMode(){
        if self.addContentBtn.isHidden == false {
            self.addContentBtn.isHidden = true
            self.addNameLbl.isHidden = false
            self.addDeliverTimeLbl.isHidden = false
            self.addDeliverRangeLbl.isHidden = false
            self.addDeliverRangeKmLbl.isHidden = false
            self.addDetailLbl.isHidden = false
            self.addName.isHidden = false
            self.addDeliverTime.isHidden = false
            self.addDeliverRange.isHidden = false
            self.addDetail.isHidden = false
            self.addConfirmBtn.isHidden = false
        }else{
            self.addContentBtn.isHidden = false
            self.addNameLbl.isHidden = true
            self.addDeliverTimeLbl.isHidden = true
            self.addDeliverRangeLbl.isHidden = true
            self.addDeliverRangeKmLbl.isHidden = true
            self.addDetailLbl.isHidden = true
            self.addName.isHidden = true
            self.addDeliverTime.isHidden = true
            self.addDeliverRange.isHidden = true
            self.addDetail.isHidden = true
            self.addConfirmBtn.isHidden = true
        }
        
    }
    
    
    
    // ====== MY Functions collection ======
    
    // TO UPDATE content in - "contents: [ContentModel]" by String(id)
    
    func updateContent(content: ContentModel) -> Bool{
        var index = 0
        for each in userContents {
            if(content.id == each.id){
                userContents[index] = content
                return true
            }
            index += 1
        }
        return false
    }
    
    
    // To DELETE content in - "contents: [ContentModel]" by String(id)
    
    func deleteContent(content: ContentModel){
        var index = 0
        for each in userContents {
            if(content.id == each.id){
                userContents.remove(at: index)
                return
            }
            index += 1
        }
    }
    
    

}

