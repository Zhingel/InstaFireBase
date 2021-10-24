//
//  UserProfileHeader.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 24.10.2021.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    let profileImage = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        addSubview(profileImage)
        profileImage.constraints(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 80, height: 80)
        profileImage.backgroundColor = .red
        profileImage.layer.cornerRadius = 80/2
        profileImage.clipsToBounds = true
        
        
    }
    
    var user: User? {
        didSet {
            guard let profileImageURL = user?.profileImageURL else {return}
            guard let url = URL(string: profileImageURL) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Failed to fetch profile Image:", error)
                    return
                }
                guard let data = data else {return}
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }.resume()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
