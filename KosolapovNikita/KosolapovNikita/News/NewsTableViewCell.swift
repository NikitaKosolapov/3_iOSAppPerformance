//
//  NewsTableViewCell.swift
//  KosolapovNikita
//
//  Created by Nikita on 12/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

@IBDesignable class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: CircleImageWithShadowView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textDescription: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likeControl: ButtonAndCounterControl!
    @IBOutlet weak var viewsCounterControl: ButtonAndCounterControl!
    @IBOutlet weak var commentControl: ButtonAndCounterControl!
    @IBOutlet weak var reposts: ButtonAndCounterControl!
}
