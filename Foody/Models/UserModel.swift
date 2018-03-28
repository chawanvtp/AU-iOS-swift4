//
//  UserModel.swift
//  Foody
//
//  Created by Dhitipong Thivakorakot on 19/3/2561 BE.
//  Copyright © 2561 CS3432. All rights reserved.
//
import Firebase



class UserModel: NSObject {
    var id: String
    var name: String
    var password: String
    var location: String
    var stores: [String]
    
    init(id: String, name: String, password: String, location: String, stores: [String]){
        self.id = id
        self.name = name
        self.password = password
        self.location = location
        self.stores = stores
    }
    
    convenience override init() {
        self.init(id: "", name: "", password: "", location: "", stores: [])
    }
}
