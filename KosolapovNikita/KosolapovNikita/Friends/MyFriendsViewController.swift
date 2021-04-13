//
//  MyCommunitiesViewController.swift
//  KosolapovNikita
//
//  Created by Nikita on 07/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class MyFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Realm properties
    var token: NotificationToken?
    var users: Results<User>?
    
    // Processed values
    var sortedUsers = [User]()
    var usersInAlphabeticalOrder = [[User]]()
    var firstLettersOfNames = [Character]()
    
    // Search bar properties
    var filteredUsers = [User]()
    var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    private var searchBarIsActive: Bool = false
    private var isFiltering: Bool {
        return !searchBarIsEmpty && searchBarIsActive
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define delegates of table view and search bar
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: "MyFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "MyFriendsTableViewCell")
        
        // Observe for users in a Realm
        pairTableWithRealm()
        
        // Get users from a server
        MakeRequest.shared.getMyFriendsList()
    }
    
    func pairTableWithRealm() {
        guard let realm = try? Realm() else { return }
        users = realm.objects(User.self)
        
        token = users!.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                break
            case .update(let friends, _, _, _):
                self?.handleFriends(friends: friends)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func handleFriends(friends: Results<User>) {
        
        guard let tableView = self.tableView else { return }
        
        // Sort users by last name
        sortedUsers = friends.sorted{$0.lastName < $1.lastName}
        
        // Get array of friends in alphabetical order
        for user in sortedUsers {
            if firstLettersOfNames.contains(user.lastName.first!) {
                usersInAlphabeticalOrder[usersInAlphabeticalOrder.count - 1].append(user)
            } else {
                firstLettersOfNames.append(user.lastName.first!)
                usersInAlphabeticalOrder.append([user])
            }
        }
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension MyFriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        } else {
            return usersInAlphabeticalOrder.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        } else {
            return usersInAlphabeticalOrder[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsTableViewCell", for: indexPath) as! MyFriendsTableViewCell// declare cell
        
        // Animation of appearance of cells and userImages
        cell.userImage.alpha = 0
        
        UIView.animate(withDuration: 1,
                       animations: {
                        cell.userImage.alpha = 1
        })
        
        UIView.animate(withDuration: 1,
                       delay: 0.1,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: [],
                       animations: {
                        cell.frame.origin.x -= 100
        })
        
        // Configurate cells
        var user: User
        
        if isFiltering { // if searchBar activated
            user = filteredUsers[indexPath.row]
        } else {
            user = usersInAlphabeticalOrder[indexPath.section][indexPath.row]
        }
        
        cell.selectionStyle = .none
        
        // Set user's name to the cell
        cell.userName.text = user.lastName + " " + user.firstName
        
        // Set user's image to the cell
        if let imageUrl = URL(string: user.avatarUrl) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.userImage.imageView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return .none
        } else {
            return "\(self.firstLettersOfNames[section])"
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProfilePhotos" { // check segue identifier
            if let indexPath = self.tableView.indexPathForSelectedRow { // get the index path to the controller's selected row
                let photoController = segue.destination as! PhotoController // get the link to the controller
                
                var user: User
                
                if isFiltering { // if search bar is active
                    user = filteredUsers[indexPath.row]
                } else {
                    user = usersInAlphabeticalOrder[indexPath.section][indexPath.row]
                }
                photoController.ownerId = user.id // set profile photo
            }
        }
    }
}

extension MyFriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowProfilePhotos", sender: nil)
    }
}

// MARK: UISearchBarDelegate

extension MyFriendsViewController: UISearchBarDelegate {
    
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
        filteredUsers = users!.filter({(user: User) in
            return user.lastName.lowercased().contains(searchText.lowercased())
        })
        if(filteredUsers.count == 0){
            searchBarIsActive = false;
        } else {
            searchBarIsActive = true;
        }
        tableView.reloadData()
    }
}



