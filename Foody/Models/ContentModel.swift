//
//  ContentModel.swift
//  Foody
//
//  Created by Dhitipong Thivakorakot on 20/3/2561 BE.
//  Copyright © 2561 CS3432. All rights reserved.
//

import UIKit
import Firebase

class ContentModel: NSObject {

    var id: String
    var imageURL: [String]
    var name: String
    var location: String
    var deliverTime: String
    var deliverRange: String
    var status: String
    var ownerID: String
    var owner: String
    var menu: [String]
    var contact: String
    var detail: String
    
    init(id: String, imageURL: [String], name: String, location: String, deliverTime: String, deliverRange: String, status: String, ownerID: String, owner: String,contact: String, detail: String, menu: [String]) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.location = location
        self.deliverTime = deliverTime
        self.deliverRange = deliverRange
        self.status = status
        self.ownerID = ownerID
        self.owner = owner
        self.menu = menu
        self.contact = contact
        self.detail = detail
    }
    
    init?(snapshot: DataSnapshot){
        
        guard let value = snapshot.value as? [String: Any] else { return nil }
        let id = snapshot.key
        guard let imageURL = value["imageURL"] as? [String]  else { return nil }
        guard let name = value["name"] as? String  else { return nil }
        guard let location = value["location"] as? String  else { return nil }
        guard let deliverTime = value["deliverTime"] as? String  else { return nil }
        guard let deliverRange = value["deliverRange"] as? String  else { return nil }
        guard let status = value["status"] as? String  else { return nil }
        guard let ownerID = value["ownerID"] as? String  else { return nil }
        guard let owner = value["owner"] as? String  else { return nil }
        guard let menu = value["menu"] as? [String] else { return nil }
        guard let contact = value["contact"] as? String else { return nil }
        guard let detail = value["detail"] as? String else { return nil }
        
        
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.location = location
        self.deliverTime = deliverTime
        self.deliverRange = deliverRange
        self.status = status
        self.ownerID = ownerID
        self.owner = owner
        self.menu = menu
        self.contact = contact
        self.detail = detail
    }
    
    convenience override init() {
        self.init(id: "", imageURL: [], name: "", location: "", deliverTime: "", deliverRange: "", status: "", ownerID: "", owner: "", contact: "", detail: "", menu: [])
    }
 
    
    
}
