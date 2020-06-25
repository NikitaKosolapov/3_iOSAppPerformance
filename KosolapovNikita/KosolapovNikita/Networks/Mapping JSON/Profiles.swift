//
//  Profiles.swift
//  KosolapovNikita
//
//  Created by Nikita on 22.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation

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
