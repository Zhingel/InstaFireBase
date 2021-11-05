//
//  CommentsController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 04.11.2021.
//

import Foundation
import UIKit
class CommentsController: UICollectionViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        
    }
    @objc func addComment() {
        print("Inserting comment:", commentTextField.text ?? "")
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        let deviderView = UIView()
        deviderView.backgroundColor = .lightGray
        containerView.addSubview(textFieldView)
        textFieldView.constraints(top: containerView.topAnchor, bottom: containerView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 15, paddingBottom: -25, paddingLeft: 20, paddingRight: 10, width: 0, height: 0)
        containerView.addSubview(deviderView)
        deviderView.constraints(top: containerView.topAnchor, bottom: nil, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: 0, height: 0.5)
        return containerView
    }()
    lazy var textFieldView: UIView = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        let textFieldView = UIView()
        textFieldView.layer.borderWidth = 0.5
        textFieldView.layer.cornerRadius = 20
        textFieldView.layer.borderColor = UIColor.lightGray.cgColor
        textFieldView.addSubview(sendButton)
        sendButton.constraints(top: textFieldView.topAnchor, bottom: textFieldView.bottomAnchor, left: nil, right: textFieldView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 10, width: 50, height: 0)
        textFieldView.addSubview(commentTextField)
        commentTextField.constraints(top: textFieldView.topAnchor, bottom: textFieldView.bottomAnchor, left: textFieldView.leftAnchor, right: sendButton.leftAnchor, paddingTop: 8, paddingBottom: -8, paddingLeft: 20, paddingRight: 8, width: 0, height: 0)
        return textFieldView
    }()
    let commentTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter Comment"
        return text
    }()
    override var inputAccessoryView: UIView? {
        get {
          return containerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
