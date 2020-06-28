//
//  VKService.swift
//  KosolapovNikita
//
//  Created by Nikita on 05.05.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class MakeRequest {
    
    static let shared = MakeRequest()
    
    private init() {}
    
    let initialUrl = "https://api.vk.com/method" // define initial url
    let accessToken = Session.shared.token // get current token
    
    func getMyFriendsList() {
        let parameters: Parameters = ["access_token": accessToken, "fields": "photo_200", "v": 5.103]
        let path = "/friends.get"
        let url = initialUrl + path
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
                guard let data = response.value else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(MainUserResponse.self, from: data).response.items
                    self?.saveData(decodedResponse)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getPhotosOfSelectedFriend(ownerId: Int) {
        let parameters: Parameters = ["access_token": Session.shared.token, "extended": 1, "owner_id": ownerId, "album_id": "profile", "v": 5.103]
        let path = "/photos.get"
        let url = initialUrl + path
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
                guard let data = response.value else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(MainPhotosResponse.self, from: data).response.items
                    self?.saveData(decodedResponse)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getMyGroupsList() {
        let parameters: Parameters = ["access_token": Session.shared.token, "fields": "activity", "extended": 1, "v": 5.103]
        let path = "/groups.get"
        let url = initialUrl + path
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
                guard let data = response.value else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(MainMyGroupsResponse.self, from: data).response.items
                    self?.saveData(decodedResponse)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getAllGroupsList(request: String, completion: @escaping ([AllGroup]) -> Void) {
        let parameters: Parameters = ["access_token": Session.shared.token, "q": request, "type": "group", "v": 5.103]
        let path = "/groups.search"
        let url = initialUrl + path
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: parameters).responseData { response in
                guard let data = response.value else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(AllGroupsResponse.self, from: data).response.items
                    completion(decodedResponse)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getNews(completion: @escaping (NewsResponse?) -> Void) {
        let parameters: Parameters = ["access_token": Session.shared.token, "filters": "post", "count": 20, "v": 5.58]
        let path = "/newsfeed.get"
        let url = initialUrl + path
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: parameters).responseData { response in
                
                guard let data = response.value else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(NewsResponse.self, from: data)
                    completion(decodedResponse)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    func saveData<T: Object & Decodable>(_ arrayOfObjects: [T]){
        do {
            let realm = try Realm()
            //            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            //            let realm = try Realm(configuration: config)
            let oldObject = realm.objects(T.self)
            realm.beginWrite()
            realm.delete(oldObject)
            realm.add(arrayOfObjects)
            try realm.commitWrite()
            print(realm.configuration.fileURL!)
        } catch {
            print(error)
        }
    }
}
