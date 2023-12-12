//
//  ActivityModel.swift
//  TouristActivitiesApp
//
//  Created by iMac on 21/11/21.
//

import Foundation
import ObjectMapper


class ActivityModel: Mappable {
    
    var id: Int?
    var city: String?
    var name: String?
    var description: String?
    var rating: Int?
    var host: String?
    var photo: [String]?
    var price: Int?
    var contact: String?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    
    func mapping(map: Map) {
        id <- map["id"]
        city <- map["city"]
        name <- map["name"]
        description <- map["description"]
        rating <- map["rating"]
        host <- map["host"]
        photo <- map["photo"]
        price <- map["price"]
        contact <- map["contact"]
    }
    
}
