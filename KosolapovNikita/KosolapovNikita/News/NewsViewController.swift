//
//  NewsViewController.swift
//  KosolapovNikita
//
//  Created by Nikita on 12/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
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
        
        // Check allNews != nil
        guard let allNews = allNews else { return UITableViewCell() }
        
        // Define news
        let news = allNews.response.items[indexPath.row]
        
        // Define source ID
        let sourceId = news.sourceId
        
        // Define owner of news (see documentation of VK API)
        if sourceId > 0 {
            let profiles = allNews.response.profiles.first(where: {$0.id == sourceId})
            cell.configure(news: news, profiles: profiles, groups: nil)
        } else {
            let groups = allNews.response.groups.first(where: {$0.id == abs(sourceId)})
            cell.configure(news: news, profiles: nil, groups: groups)
        }
        
        return cell
    }
}
