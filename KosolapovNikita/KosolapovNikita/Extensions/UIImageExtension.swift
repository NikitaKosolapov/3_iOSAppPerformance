//
//  UIImageExtension.swift
//  KosolapovNikita
//
//  Created by Nikita on 28.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

extension UIImage {
    static func setImage(from url: String) -> UIImage? {
        guard let imageUrl = URL(string: url) else { return nil }
        var image: UIImage? = nil
        do {
            let data = try Data(contentsOf: imageUrl)
            image = UIImage(data: data)
        } catch {
            print(error)
        }
        return image
    }
}

extension UIImage {
    static func getImage(from string: String) -> UIImage? {
        guard let url = URL(string: string)
            else {
                print("Unable to create URL")
                return nil
        }
        
        var image: UIImage? = nil
        do {
            let data = try Data(contentsOf: url, options: [])
            image = UIImage(data: data)
        }
        catch {
            print(error.localizedDescription)
        }
        return image
    }
}
