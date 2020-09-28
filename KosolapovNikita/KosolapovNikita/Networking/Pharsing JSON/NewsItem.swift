//
//  NewsItem.swift
//  KosolapovNikita
//
//  Created by Nikita on 28.09.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import SwiftyJSON

final class NewsItem {
    
    enum NewsItemType: String {
        case post
        case wallPhoto = "wall_photo"
    }
    
    var sourceId: Int = 0
    var date: Date
    var type: NewsItemType
    var likesCount: Int = 0
    var repostsCount: Int = 0
    var commentsCount: Int = 0
    var viewsCount: Int = 0
    var photoUrl: String = ""
    var text: String = ""
    
    init(json: JSON) {
        self.sourceId = json["source_id"].intValue
        self.date = {
            let timeInterval = json["date"].doubleValue
            let date = Date(timeIntervalSince1970: timeInterval)
            return date
        }()
        self.type = NewsItemType(rawValue: json["type"].stringValue) ?? .post
        self.likesCount = json["likes"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.viewsCount = json["views"]["count"].intValue
        
        switch self.type {
        case .post:
            self.text = json["text"].stringValue
        case .wallPhoto:
            self.photoUrl = json["photos"]["items"]
                .arrayValue
                .first?["photo_604"]
                .string ?? ""
        }
    }
}
