//
//  NewsViewController.swift
//  KosolapovNikita
//
//  Created by Nikita on 12/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allNews: NewsResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        MakeRequest.shared.getNews { [weak self] news in
            self?.allNews = news
            self?.tableView.reloadData()
        }
    }
}

extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let allNews = allNews else { return 0 }
        return allNews.response.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = .none
        
        guard let allNews = allNews else { return cell }
        
        func setImageToTheUserImage(string: String){
            if let imageUrl = URL(string: string) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageUrl)
                    if let data = data {
                        let image = UIImage(data: data)
                        guard image != nil else { return }
                        DispatchQueue.main.async {
                            cell.userImage.imageView.image = image
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
                        guard image != nil else { return }
                        DispatchQueue.main.async {
                            cell.photo.image = image
                        }
                    }
                }
            }
        }
    
        
        // Description
        cell.textDescription.text = allNews.response.items[indexPath.row].text
        let sourceId = allNews.response.items[indexPath.row].sourceId
        
        // Name and icon
        if sourceId > 0  {
            if let profile = allNews.response.profiles.first(where: {$0.id == sourceId}) {
                cell.name.text = profile.firstName + " " + profile.lastName
                setImageToTheUserImage(string: profile.photo)
            }
        } else { // group name
            if let group = allNews.response.groups.first(where: {$0.id == abs(sourceId)}) {
                cell.name.text = group.name
                setImageToTheUserImage(string: group.photo)
            }
        }
        
        // Photo of news
        if let typeOfContent = allNews.response.items[indexPath.row].attachments?[0].type {
            switch typeOfContent {
                  case "photo":
                      if let photo = allNews.response.items[indexPath.row].attachments?[0].photo?.photo {
                          setImageToThePhotoImage(string: photo)
                      }
                  case "video":
                      if let photo = allNews.response.items[indexPath.row].attachments?[0].video?.photo {
                          setImageToThePhotoImage(string: photo)
                      }
                  case "album":
                      if let photo = allNews.response.items[indexPath.row].attachments?[0].album?.thumb.photo {
                          setImageToThePhotoImage(string: photo)
                      }
                  default:
                      return cell
                  }
        }
        
      
        
        // Likes
        cell.likeControl.counter = allNews.response.items[indexPath.row].likes.count
        cell.likeControl.setupView()
        
        // Comments
        cell.commentControl.counter = allNews.response.items[indexPath.row].comments.count
        cell.commentControl.setupView()
        
        // Reposts
        cell.reposts.counter = allNews.response.items[indexPath.row].reposts.count
        cell.reposts.setupView()
        
        // Date
        let date = Date(timeIntervalSince1970: TimeInterval(allNews.response.items[indexPath.row].date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        cell.date.text = localDate
        
        return cell
    }
}
