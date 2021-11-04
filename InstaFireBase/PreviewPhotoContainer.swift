//
//  PreviewPhotoContainer.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 03.11.2021.
//

import Foundation
import UIKit

class PreviewPhotoContainer: UIViewController {
    var selectedImage: UIImage?
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(cancelButton)
        view.addSubview(dismissButton)
        let height = (view.bounds.height - view.bounds.width)/2
        cancelButton.constraints(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: nil, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 50, height: 50)
        imageView.constraints(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: height, paddingBottom: -height, paddingLeft: 0, paddingRight: 0, width: view.bounds.width, height: view.bounds.width)
        dismissButton.constraints(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 50, height: 50)
    }
  
    
    @objc fileprivate func handleCancel() {
//        self.removeFromSuperview()
        dismiss(animated: false)
    }
    
    @objc func handleDismiss() {
    //    dismiss(animated: true)
        let viewController = EditTextViewController()
        viewController.selectedImage = self.selectedImage
        navigationController?.pushViewController(viewController, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
