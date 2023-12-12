//
//  UserModel.swift
//  TouristActivitiesApp
//
//  Created by iMac on 20/11/21.
//

import Foundation
import ObjectMapper

class UserModel: Mappable {
    
    var id: Int?
    var email: String?
    var password: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        password <- map["password"]
    }
    
}
