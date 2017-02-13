

import UIKit
extension UIImageView {
    
    // http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    func downloadAndSetImage(link: String) {
        guard let url = NSURL(string: link) else {
            return
        }
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    return
            }
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
    
}

