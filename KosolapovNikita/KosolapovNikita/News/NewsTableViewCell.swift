//
//  NewsTableViewCell.swift
//  KosolapovNikita
//
//  Created by Nikita on 12/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

@IBDesignable class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var userImage: CircleImageWithShadowView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var likeControl: ButtonAndCounterControl!
    @IBOutlet private weak var commentControl: ButtonAndCounterControl!
    @IBOutlet private weak var repostsControl: ButtonAndCounterControl!
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
    
    private var attachments: Attachments?
    
    func configure(news: News, profiles: Profiles?, groups: AllGroup?) {
        
        // User image and name
        if let profiles = profiles {
            self.userImage.imageView.loadImageUsingCache(withUrl: profiles.photo)
            self.nameLabel.text = profiles.firstName + " " + profiles.lastName
        } else if let groups = groups {
            self.userImage.imageView.loadImageUsingCache(withUrl: groups.photo)
            self.nameLabel.text = groups.name
        }
        
        // Date
        self.dateLabel.text = {
            let date = Date(timeIntervalSince1970: TimeInterval(news.date))
            return dateFormatter.string(from: date)
        }()
        
        // Text description
        descriptionLabel.text = news.text
        
        // Photo
        let copyHistoryAttachments = news.copyHistory?[0].attachments?[0]
        let itemsAttachments = news.attachments?[0]
        
        if (copyHistoryAttachments?.type) != nil {
            self.attachments = copyHistoryAttachments
        } else if (itemsAttachments?.type) != nil {
            self.attachments = itemsAttachments
        }
        
        switch attachments?.type {
        case "photo":
            if let urlOfPhoto = attachments?.photo?.photo {
                self.photoImageView.loadImageUsingCache(withUrl: urlOfPhoto)
            }
        case "video":
            if let urlOfPhoto = attachments?.video?.photo {
                self.photoImageView.loadImageUsingCache(withUrl: urlOfPhoto)
            }
        case "album":
            if let urlOfPhoto = attachments?.album?.thumb.photo {
                self.photoImageView.loadImageUsingCache(withUrl: urlOfPhoto)
            }
        default:
            return
        }
        
        // Likes
        self.likeControl.counter = news.likes.count
        self.likeControl.setupView()
        
        // Comments
        self.commentControl.counter = news.comments.count
        self.commentControl.setupView()
        
        // Reposts
        self.repostsControl.counter = news.reposts.count
        self.repostsControl.setupView()
    }
}
