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
    let savedImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let savedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "save_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func handleSave() {
        guard let images = selectedImage else {return}
            UIImageWriteToSavedPhotosAlbum(images, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error)
           
        } else {
            ////////////
            savedImageView.image = self.selectedImage
            showSavedImage()
            
        }
    }
    func showSavedImage() {
        view.addSubview(savedView)
        savedView.addSubview(savedImageView)
        savedImageView.constraints(top: savedView.topAnchor, bottom: savedView.bottomAnchor, left: savedView.leftAnchor, right: savedView.rightAnchor, paddingTop: 5, paddingBottom: -5, paddingLeft: 5, paddingRight: 5, width: 0, height: 0)
        savedView.constraints(top: nil, bottom: saveButton.topAnchor, left: view.leftAnchor, right: nil, paddingTop: 0, paddingBottom: -10, paddingLeft: 12, paddingRight: 0, width: 70, height: 70)
        UIView.animate(withDuration: 0.5, delay: 1, options: [.beginFromCurrentState], animations: {
//            self.savedView.center.x += 200
        }) {finish in
            UIView.animate(withDuration: 0.5, delay: 1, options: [.beginFromCurrentState], animations: {
            self.savedView.center.x -= 200
            }) {finish in
                self.savedView.removeFromSuperview()
            }
            self.saveButton.isEnabled = false
            self.saveButton.alpha = 0.7
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(cancelButton)
        view.addSubview(dismissButton)
        view.addSubview(saveButton)
        let height = (view.bounds.height - view.bounds.width)/2
        saveButton.constraints(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: nil, paddingTop: 0, paddingBottom: -12, paddingLeft: 12, paddingRight: 0, width: 50, height: 50)
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
