//
//  Profiles.swift
//  KosolapovNikita
//
//  Created by Nikita on 22.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Profiles: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_100"
    }
}

//final class Profiles {
//    let id: Int
//    let name: String
//    let photoUrl: String
//
//    init(json: JSON) {
//        self.id = json["id"].intValue
//        self.name = {
//            let firstName = json["first_name"].stringValue
//            let lastName = json["last_name"].stringValue
//            let name = firstName + " " + lastName
//            return name
//        }()
//        self.photoUrl = json["photo_100"].stringValue
//    }
//}
