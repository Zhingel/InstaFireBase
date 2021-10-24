//
//  UserProfileHeader.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 24.10.2021.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        image.layer.cornerRadius = 80/2
        image.clipsToBounds = true
        return image
    }()
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        return button
    }()
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubview(profileImage)
        profileImage.constraints(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 80, height: 80)
        tabbarView()
    }
    
    fileprivate func tabbarView() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        addSubview(stackView)
        stackView.constraints(top: nil, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 30)
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
