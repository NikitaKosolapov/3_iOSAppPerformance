//
//  AllGroupsTableViewCell.swift
//  KosolapovNikita
//
//  Created by Nikita on 10.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class AllGroupsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupImage: CircleImageWithShadowView!
    @IBOutlet weak var groupName: UILabel!
    
    func configure(groups: AllGroup) {
        
        // Icon
        let url = groups.photo
        setUpImage(url: url)
        
        // Name
        self.groupName.text = groups.name
    }
    
    func setUpImage(url: String) {
        if let imageUrl = URL(string: url) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: imageUrl)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.groupImage.imageView.image = image
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
