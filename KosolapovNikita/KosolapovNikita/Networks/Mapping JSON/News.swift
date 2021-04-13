//
//  News.swift
//  KosolapovNikita
//
//  Created by Nikita on 12.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation

struct NewsResponse: Codable {
    let response: NewsItems
}

struct NewsItems: Codable {
    let items: [News]
    let profiles: [Profiles]
    let groups: [AllGroup]
}

struct News: Codable {
    let sourceId: Int
    let date: Double
    let attachments: [Attachments]?
    let text: String
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let copyHistory: [Attachments]?
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case date 
        case attachments
        case text
        case comments
        case likes
        case reposts
        case copyHistory = "copy_history"
    }
}

struct Attachments: Codable {
    let type: String?
    let photo: NewsPhoto?
    let video: NewsVideo?
    let album: NewsAlbum?
}

struct NewsAlbum: Codable {
    let thumb: Thumb
}

struct Thumb: Codable {
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case photo = "photo_604"
    }
}

struct NewsPhoto: Codable {
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case photo = "photo_604"
    }
}

struct NewsVideo: Codable {
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case photo = "photo_800"
    }
}


struct Comments: Codable {
    let count: Int
}

struct  Likes: Codable {
    let count: Int
}

struct Reposts: Codable {
    let count: Int
}



