//
//  UIImageExtension.swift
//  KosolapovNikita
//
//  Created by Nikita on 28.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func getImage(from url: String) -> UIImage? {
        
        var image: UIImage? = nil
            guard let imageUrl = URL(string: url) else { return nil }
            do {
                let data = try Data(contentsOf: imageUrl)
                image = UIImage(data: data)
            } catch {
                print(error)
            }
        return image
        }
        
    
}

