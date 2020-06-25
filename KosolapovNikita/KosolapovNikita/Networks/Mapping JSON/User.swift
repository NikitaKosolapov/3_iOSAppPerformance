//
//  User.swift
//  KosolapovNikita
//
//  Created by Nikita on 14.05.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import RealmSwift

class MainUserResponse: Decodable {
    let response: UserResponse
}

class UserResponse: Decodable {
    let items: [User]
}

class User: Object, Decodable {

    @objc dynamic var id = Int()
    @objc dynamic var avatarUrl = String()
    @objc dynamic var firstName = String()
    @objc dynamic var lastName = String()
    
    enum CodingKeys: String, CodingKey {
        case id
        case avatarUrl = "photo_200"
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
