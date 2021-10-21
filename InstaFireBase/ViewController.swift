//
//  ViewController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 19.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let emailTextfield = UITextField(placeholder: "Email")
    let userNameTextfield = UITextField(placeholder: "Username")
    let passwordTextfield: UITextField = {
        let tf = UITextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSignUpView()
       
    }
    
    
    
    
    
    
    
    
    

    fileprivate func setupSignUpView() {
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.constraints(top: view.topAnchor, bottom: nil, left: nil, right: nil, paddingTop: 100, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailTextfield, userNameTextfield, passwordTextfield, signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.constraints(top: plusPhotoButton.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: 40, width: 0, height: 200)
    }
}

