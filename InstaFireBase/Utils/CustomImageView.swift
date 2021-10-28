//
//  CustomImageView.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 28.10.2021.
//

import Foundation
import UIKit
class CustomImageView: UIImageView {
    var lastURL: String?
    func loadImage(urlString: String) {
        lastURL = urlString
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetch image", error)
                return
            }
            if url.absoluteString != self.lastURL {return}
            guard let data = data else {return}
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
        }.resume()
    }
}
