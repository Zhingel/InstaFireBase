//
//  EditTextViewController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 27.10.2021.
//

import Foundation
import UIKit

class EditTextViewController: UIViewController {
    var selectedImage: UIImage? {
        didSet {
            imageView.image =  selectedImage
        }
    }
    let imageView: UIImageView = {
        let iv = UIImageView()
        let vc = PhotoSelectorController()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let appearance = UINavigationBarAppearance()
           appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImagesAndTextViews()
    }
    fileprivate func setupImagesAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        let devider = UIView()
        devider.backgroundColor = .lightGray
        view.addSubview(containerView)
        view.addSubview(devider)
        containerView.addSubview(imageView)
        containerView.addSubview(textView)
        containerView.constraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 100)
        devider.constraints(top: containerView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        imageView.constraints(top: containerView.topAnchor, bottom: containerView.bottomAnchor, left: containerView.leftAnchor, right: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 84, height: 0)
        textView.constraints(top: containerView.topAnchor, bottom: containerView.bottomAnchor, left: imageView.rightAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 4, paddingRight: 0, width: 0, height: 0 )
    }
    @objc func handleShare() {
        print("share")
    }
    @objc func handleBack() {
        print("go back")
        let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor.black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
