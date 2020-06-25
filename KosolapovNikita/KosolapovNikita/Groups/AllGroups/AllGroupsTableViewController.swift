//
//  AllGroupsViewController.swift
//  KosolapovNikita
//
//  Created by Nikita on 10.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class AllGroupsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchBarIsActive = Bool()
    
    var allGroups = [AllGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "AllGroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllGroupsTableViewCell")
        
    }
}

extension AllGroupsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsTableViewCell", for: indexPath) as! AllGroupsTableViewCell
        
        guard let imageUrl = URL(string: allGroups[indexPath.row].photo) else { return cell }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: imageUrl)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.groupImage?.imageView.image = image
                }
            } catch {
                print(error)
            }
        }
        
        cell.groupName.text = self.allGroups[indexPath.row].name
        
        return cell
    }
}

extension AllGroupsTableViewController: UISearchBarDelegate {
    
    private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBarIsActive = true;
    }
    
    private func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBarIsActive = false;
    }
    
    private func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarIsActive = false;
    }
    
    private func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBarIsActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            allGroups = [AllGroup]()
            self.tableView.reloadData()
        } else {
            MakeRequest.shared.getAllGroupsList(request: searchText) { [weak self] allGroups in
                self?.allGroups = allGroups
                self?.tableView.reloadData()
            }
        }
    }
}
