//
//  User.swift
//  SpeedySloth
//
//  Created by Razvan Rujoiu on 06/07/2018.
//  Copyright © 2018 Apple, Inc. All rights reserved.
//

import Foundation
class User: NSObject {
    var id: String?
    var  username: String?
    var  email: String?
    init(dictionary: [String:AnyObject]){
        self.id = dictionary["id"] as? String
        self.username = dictionary["username"] as? String
        self.email = dictionary["email"] as? String
    }
    
}
