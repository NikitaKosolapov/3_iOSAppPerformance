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
    
    var allNews: [News]?
    var profiles: [Profiles]?
    var groups: [AllGroup]?
    var refreshControl = UIRefreshControl()
    var nextFrom = ""
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        tableView.prefetchDataSource = self
        tableView.delegate = self
        
        setupRefreshControl()
        
        MakeRequest.shared.getNews() { [weak self] (news,nextFrom)  in
            self?.allNews = news?.response.items
            self?.profiles = news?.response.profiles
            self?.groups = news?.response.groups
            guard let nextFrom = nextFrom else { return }
            self?.nextFrom = nextFrom
            self?.tableView.reloadData()
        }
    }
    
    func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(self.refreshNews), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshNews() {
        self.refreshControl.beginRefreshing() // begin updating
        let mostFreshNewsDate = self.allNews?.first?.date ?? Date().timeIntervalSince1970 // define most fresh news or take current time
        MakeRequest.shared.getNews(startTime: mostFreshNewsDate + 1) { [weak self] (news,nextFrom) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing() // turn off refreshControl
            guard let allNews = self.allNews,
                let news = news?.response.items,
                news.count > 0 else { return }
            self.allNews = news + allNews
            let indexSet = IndexSet(integersIn: 0..<news.count)
            self.tableView.insertSections(indexSet, with: .automatic)
        }
    }
}

extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let allNews = allNews else { return 0 }
        return allNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = .none
        
        // Check allNews != nil
        guard let allNews = allNews else { return UITableViewCell() }
        
        // Define news
        let news = allNews[indexPath.row]
        
        // Define source ID
        let sourceId = news.sourceId
        
        // Define owner of news (see documentation of VK API)
        if sourceId > 0 {
            let profiles = self.profiles?.first(where: {$0.id == sourceId})
            cell.configure(news: news, profiles: profiles, groups: nil)
        } else {
            let groups = self.groups?.first(where: {$0.id == abs(sourceId)})
            cell.configure(news: news, profiles: nil, groups: groups)
        }
        return cell
    }
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let allNews = allNews,
            let maxRow = indexPaths.map({$0.row}).max()else { return }
        print(maxRow)
        if maxRow > allNews.count - 3,
            !isLoading {
            isLoading = true
            MakeRequest.shared.getNews(startFrom: nextFrom) { [weak self] (news, nextFrom) in
                guard let self = self,
                    let news = news,
                    let nextFrom = nextFrom else { return }
                self.nextFrom = nextFrom
                let indexSet = IndexSet(integersIn: self.allNews!.count..<self.allNews!.count + news.response.items.count)
                let indexPaths = indexSet.map{IndexPath(row:$0, section:0)}
                self.allNews?.append(contentsOf: news.response.items)
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                self.isLoading = false
            }
        }
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            let tableWidth = tableView.bounds.width
            let news = self.allNews![indexPath.row]
            let cellHeight = tableWidth * news.attachments
            return cellHeight
        default:
            return UITableView.automaticDimension
        }
    }
}
