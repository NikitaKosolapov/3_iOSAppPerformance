//
//  MyFriendsTableViewCell.swift
//  KosolapovNikita
//
//  Created by Nikita on 02/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: CircleImageWithShadowView!
    @IBOutlet weak var userName: UILabel!
    
    @IBAction func userImageAnimate() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity:  0,
                       options: [.curveEaseOut],
                       animations: {
                        self.userImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                        self.userImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func configure(friend: User) {
        
        // Icon
        let url = friend.avatarUrl
        self.userImage.imageView.loadImageUsingCache(withUrl: url)
        
        // Name
        self.userName.text = friend.lastName + " " + friend.firstName
    }
}
