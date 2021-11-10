//
//  TextView.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 10.11.2021.
//

import Foundation
import UIKit

protocol CustomTextViewDelegate {
    func addCommentFunc(for commentTextDelegate: String)
}
class CustomTextView: UIView, UITextFieldDelegate {
    var delegate: CustomTextViewDelegate?
    var tapp: (()->Void)?
    let sendButton: UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        sendButton.isHidden = true
        sendButton.alpha = 0.7
        return sendButton
    }()
    let commentTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter Comment"
        return text
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commentTextField.delegate = self
        layer.borderWidth = 0.5
        layer.cornerRadius = 20
        layer.borderColor = UIColor.lightGray.cgColor
        addSubview(sendButton)
        sendButton.constraints(top: topAnchor, bottom: bottomAnchor, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 10, width: 50, height: 0)
        addSubview(commentTextField)
        commentTextField.constraints(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: sendButton.leftAnchor, paddingTop: 8, paddingBottom: -8, paddingLeft: 20, paddingRight: 8, width: 0, height: 0)
    }
    
    @objc func addComment() {
        guard let commentTextDelegate = commentTextField.text else {return}
        delegate?.addCommentFunc(for: commentTextDelegate)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sendButton.isHidden = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.sendButton.isHidden = true
    }
    func clearCommentTextField() {
        commentTextField.text = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
