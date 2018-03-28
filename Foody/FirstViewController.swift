//
//  FirstViewController.swift
//  Foody
//
//  Created by Dhitipong Thivakorakot on 18/3/2561 BE.
//  Copyright © 2561 CS3432. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Firebase
import FirebaseStorage


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var ref: DatabaseReference = Database.database().reference()
    lazy var storageRef: StorageReference = Storage.storage().reference()
    //var contents: Array<DataSnapshot> = []
    var contents = [ContentModel]()
    var filteredContents = [ContentModel]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Foods"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Do any additional setup after loading the view, typically from a nib.
        ref.child("contents").observe( .childAdded, with: { (snapshot) in
            
            let content = ContentModel(snapshot: snapshot)
            self.contents.append(content!)
            self.tableView.reloadData()
            
        }, withCancel: { (Error) in
            print(Error.localizedDescription)
        })
        
        ref.child("contents").observe(DataEventType.childChanged, with: { (snapshot) in
            let content = ContentModel(snapshot: snapshot)
            self.updateContent(content: content!)
            self.tableView.reloadData()
        }, withCancel: { (Error) in
            print(Error.localizedDescription)
        })
        
        ref.child("contents").observe(DataEventType.childRemoved, with: { (snapshot) in
            let content = ContentModel(snapshot: snapshot)
            self.deleteContent(content: content!)
            self.tableView.reloadData()
        }, withCancel: { (Error) in
            print(Error.localizedDescription)
        })
       
    }
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // - TO Return -> fetching table's Row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.filteredContents.count
        }
        
        return self.contents.count
    }
    
    
    // - TO Return -> fetching mainTableCell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableCell") as! MainTableCell
        let content: ContentModel
        if isFiltering() {
            content = filteredContents[indexPath.row]
        } else {
            content = contents[indexPath.row]
        }
        
        
        cell.contentName.text = content.name
        
        if(self.contents[indexPath.row].status == "Closed"){
            cell.contentStatus?.textColor = UIColor.red
        }else{
            cell.contentStatus?.textColor = UIColor.blue
        }
        
        cell.contentStatus.text = content.status
        cell.contentID.text = content.id
        cell.contentIndex.text = String(indexPath.row)
        cell.contentTime.text = "Open: " + content.deliverTime
        cell.contentDistance.text = content.deliverRange + " km"
         cell.contentImage.image = UIImage(named: content.imageURL[0])
        cell.contentDeliverRange.text = "Deliver: " + content.deliverRange + " km"
        
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
                cell.contentImage.image = image
            }
        }
        
        
        
        if tableView.isHidden && self.contents.count > 0 {
            tableView.isHidden = false
        }
        
        return cell
    }
    
    
    
    
    
    // - TO Adjust -> mainTableCell's Height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        contents = contents.filter({( content : ContentModel) -> Bool in
            return content.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        //let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //getting the text of that cell
        self.performSegue(withIdentifier: "showContentDetail", sender: indexPath!.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showContentDetail"){
            let selectedIndex = (sender as! Int)
            let nextController = segue.destination as! ContentViewController
            
            // TO Set Variable "ContentModel" in - ContentViewController
            nextController.currentContent = contents[selectedIndex]
      
        }
    }
 
    
    // ====== MY Functions collection ======
    
    // TO UPDATE content in - "contents: [ContentModel]" by String(id)
    
    func updateContent(content: ContentModel){
        var index = 0
        for each in contents {
            if(content.id == each.id){
                contents[index] = content
                return
            }
            index += 1
        }
    }
    
    
    // To DELETE content in - "contents: [ContentModel]" by String(id)
    
    func deleteContent(content: ContentModel){
        var index = 0
        for each in contents {
            if(content.id == each.id){
                contents.remove(at: index)
                return
            }
            index += 1
        }
    }
    
    
}


extension FirstViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
}
