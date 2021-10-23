//
//  ViewController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 19.10.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupSignUpView()
    }
    
    
    
    
    
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
        
    }
    @objc func handleTextInputChanged() {
        let isFormValid = emailTextfield.text?.count ?? 0 > 0 && userNameTextfield.text?.count ?? 0 > 0 && passwordTextfield.text?.count ?? 0 > 0
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 257)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    @objc func handleSignUp() {
        guard let email = emailTextfield.text, email.count > 0 else {return}
        guard let username = userNameTextfield.text, username.count > 0 else {return}
        guard let password = passwordTextfield.text, password.count > 0 else {return}
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
            if let err = error { 
                print("Failed to create user", err)
                return
            }
            print("successfuly", user?.user.uid ?? "")
            
            guard let image = self.plusPhotoButton.imageView?.image else {return}
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
            let fileName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(fileName)
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("failed to upload data")
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString {
                            print("Success")
                            guard let uid = user?.user.uid else {return}
                            let dictionaryValues = ["username" : username, "profileImageUrl" : profileImageUrl]
                            let values = [ uid : dictionaryValues]
                            Database.database().reference().child("users").updateChildValues(values) { (err, ref) in
                                if let err = err {
                                    print("error to safe user info in database", err)
                                    return
                                }
                                print("successfuly save user")
                            }
                        }
                    })
                
               
            }
        })
    }
    fileprivate func setupTextFields() {
        emailTextfield.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        userNameTextfield.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
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

