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
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var textDescription: UILabel!
    @IBOutlet private weak var photo: UIImageView!
    @IBOutlet private weak var likeControl: ButtonAndCounterControl!
    @IBOutlet private weak var commentControl: ButtonAndCounterControl!
    @IBOutlet private weak var reposts: ButtonAndCounterControl!
    
    private var typeOfContent: String = ""
    private var attachments: Attachments?
    
    func configure(news: News, profiles: Profiles?, groups: AllGroup?) {
        
        // User image and name
        if let profiles = profiles {
            setImageToTheUserImage(string: profiles.photo)
            self.name.text = profiles.firstName + " " + profiles.lastName
        } else if let groups = groups {
            setImageToTheUserImage(string: groups.photo)
            self.name.text = groups.name
        }
        
        // Date
        let date = Date(timeIntervalSince1970: TimeInterval(news.date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        self.date.text = localDate
        
        // Text description
        self.textDescription.text = news.text
        
        // Photo
        let copyHistoryAttachments = news.copyHistory?[0].attachments?[0]
        let itemsAttachments = news.attachments?[0]
        
        if let typeOfContent = copyHistoryAttachments?.type {
            self.typeOfContent = typeOfContent
            self.attachments = copyHistoryAttachments
        } else if let typeOfContent = itemsAttachments?.type {
            self.typeOfContent = typeOfContent
            self.attachments = itemsAttachments
        }
        
        switch typeOfContent {
        case "photo":
            if let urlOfPhoto = attachments?.photo?.photo {
                setImageToThePhotoImage(string: urlOfPhoto)
            }
        case "video":
            if let urlOfPhoto = attachments?.video?.photo {
                setImageToThePhotoImage(string: urlOfPhoto)
            }
        case "album":
            if let urlOfPhoto = attachments?.album?.thumb.photo {
                setImageToThePhotoImage(string: urlOfPhoto)
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
        self.reposts.counter = news.reposts.count
        self.reposts.setupView()
    }
    
    func setImageToTheUserImage(string: String){
        if let imageUrl = URL(string: string) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.userImage.imageView.image = image
                    }
                }
            }
        }
    }
    
    func setImageToThePhotoImage(string: String){
        if let imageUrl = URL(string: string) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.photo.image = image
                    }
                }
            }
        }
    }
}
