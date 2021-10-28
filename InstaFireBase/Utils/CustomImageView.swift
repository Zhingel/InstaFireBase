//
//  CustomImageView.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 28.10.2021.
//

import Foundation
import UIKit
var imageCache = [String : UIImage]()
class CustomImageView: UIImageView {
    var lastURL: String?
    func loadImage(urlString: String) {
        lastURL = urlString
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return 
        }
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetch image", error)
                return
            }
            if url.absoluteString != self.lastURL {return}
            guard let data = data else {return}
            let photoImage = UIImage(data: data)
            imageCache[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
        }.resume()
    }
}
