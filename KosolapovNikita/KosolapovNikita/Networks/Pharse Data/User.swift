//
//  User.swift
//  KosolapovNikita
//
//  Created by Nikita on 14.05.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import RealmSwift

struct User {
    var id: Int
    var photo: String
    var firstName: String
    var lastName: String
}

//class MainUserResponse: Decodable {
//    let response: UserResponse
//}
//
//class UserResponse: Decodable {
//    let items: [User]
//}
//
//class User: Object, Decodable {
//
//    @objc dynamic var id = Int()
//    @objc dynamic var photo = String()
//    @objc dynamic var firstName = String()
//    @objc dynamic var lastName = String()
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case photo = "photo_200"
//        case firstName = "first_name"
//        case lastName = "last_name"
//    }
//
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}


/*
 {
 "response": {
 "count": 80,
 "items": [{
 "id": 5368155,
 "first_name": "Виктором",
 "last_name": "Терёшиным",
 "is_closed": false,
 "can_access_closed": true,
 "domain": "id5368155",
 "city": {
 "id": 1,
 "title": "Москва"
 },
 "online": 0,
 "track_code": "a008e5a4-kBk5EHDab9XG2eI88sBhZckdfaJUFZEsAaUDb-nyaWXKzzcc8BjuVsYUi8wA9f07id1n-w"
 }]
 }
 }
 */
