import UIKit

let imageCache = NSCache<NSString, AnyObject>()
var task: URLSessionTask!
let spinner = UIActivityIndicatorView(style: .medium)

extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String) {
        
        let url = URL(string: urlString)
        self.image = nil
//        addSpinner()
        
//        if let task = task {
//            task.cancel()
//        }
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
//            self.removeSpinner()
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self?.image = image
//                    self.removeSpinner()
                }
            }
        }).resume()
    }
    
//    func addSpinner() {
//        addSubview(spinner)
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        spinner.startAnimating()
//    }
//
//    func removeSpinner() {
//        spinner.removeFromSuperview()
//    }
}
