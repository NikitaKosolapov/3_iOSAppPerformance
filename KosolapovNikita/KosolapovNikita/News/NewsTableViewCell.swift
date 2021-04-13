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
    
    func configure(item: NewsItem) {
        
        // Profile image
        self.userImage.imageView.loadImageUsingCache(withUrl: item.profile?.photoUrl ?? "")
        
        // Name
        self.nameLabel.text = item.profile?.name
        
        // Date
        self.dateLabel.text = {
            let date = item.date
            return dateFormatter.string(from: date)
        }()
        
        // Text description
        descriptionLabel.text = item.text
        
        // Photo
        self.photoImageView.loadImageUsingCache(withUrl: item.photoUrl)
        
        // Like
        self.likeControl.counter = item.likesCount
        self.likeControl.setupView()
        
        // Comments
        self.commentControl.counter = item.commentsCount
        self.commentControl.setupView()
        
        // Reposts
        self.repostsControl.counter = item.repostsCount
        self.repostsControl.setupView()
    }
}
