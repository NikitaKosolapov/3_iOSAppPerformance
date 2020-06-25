//
//  Profile.swift
//  L1_KosolapovNikita
//
//  Created by Nikita on 29/03/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.

import UIKit
import RealmSwift

class PhotoController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var token: NotificationToken?
    var photos: Results<Photo>?
    
    var ownerId = Int()
    var profileImages = [UIImage]() // Get photos for selected user
    var indexPathRow = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define collection view delegates
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pairTableWithRealm()
        MakeRequest.shared.getPhotosOfSelectedFriend(ownerId: ownerId)
    }
    
    func pairTableWithRealm() {
        guard let realm = try? Realm() else { return }
        photos = realm.objects(Photo.self)
        
        if let photos = photos {
            token = photos.observe { [weak self] (changes: RealmCollectionChange) in
                guard let collectionView = self?.collectionView else { return }
                switch changes {
                case .initial: 
                    break
                case .update(_, let deletions, let insertions, let modifications):
                    collectionView.performBatchUpdates({
                        collectionView.insertItems(at: insertions.map({IndexPath(row: $0, section: 0)}))
                        collectionView.deleteItems(at: deletions.map({IndexPath(row: $0, section: 0)}))
                        collectionView.reloadItems(at: modifications.map({IndexPath(row: $0, section: 0)}))
                    }, completion: nil)
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        }
    }
}

// Setup UICollectionView data
extension PhotoController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Setup cells
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        // Set user's image to the cell
        if let photos = photos {
            if let imageUrl = URL(string: photos[indexPath.row].url) {
                DispatchQueue.global().async {
                    do {
                        let data = try Data(contentsOf: imageUrl)
                        guard let image = UIImage(data: data) else { return }
                        self.profileImages.append(image)
                        DispatchQueue.main.async {
                            cell.image.image = image
                        }
                    } catch {
                        print(error)
                }
            }
        }
    }
    return cell
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowPhotoDetail" {
        if let selectedIndexPathRow = collectionView?.indexPathsForSelectedItems?.first?.row { // get indexPath for selected item
            if let photoDetailViewController = segue.destination as? SelectedPhotoViewController { // get link to photoDetailViewController
                photoDetailViewController.currentPhotoNumber = selectedIndexPathRow // set current photo number into photoDetailViewController
                photoDetailViewController.profileImages = profileImages
            }
        }
    }
}
}

// Setup UICollectionView flow layout
extension PhotoController: UICollectionViewDelegateFlowLayout {
    
    // Item size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemInRow: CGFloat = 3 // set number of items in rows
        let size = collectionView.bounds.width / numberOfItemInRow - 1
        
        return CGSize(width: size, height: size)
    }
    
    // Spacing in section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    // Minimum horizontal spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Minimum vertical spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
