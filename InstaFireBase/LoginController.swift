//
//  LoginController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 25.10.2021.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    let swichToSignUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "Don't have an accaunt?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributeTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 257)]))
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(switchToSignUp), for: .touchUpInside)
        return button
    }()
    let logoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        let logo = UIImageView()
        logo.image = UIImage(named: "Instagram_logo_white")
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)
        logo.constraints(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 60, paddingBottom: -20, paddingLeft: 80, paddingRight: 80, width: 0, height: 0)
        return view
    }()
    let emailLogin = UITextField(placeholder: "Email")
    let passwordLogin: UITextField = {
        let password = UITextField(placeholder: "Password")
        password.isSecureTextEntry = true
        return password
    }()
    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        emailLogin.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        passwordLogin.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        loginSetup()
    }
    @objc func handleLogin() {
        guard let email = emailLogin.text else {return}
        guard let password = passwordLogin.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("can't Login", error)
                return
            }
            print("Succesfully login", result?.user.uid ?? "")
            guard let tabBarController = UIApplication.shared.windows[0].rootViewController as? MainTabBarController else {return}
            tabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func handleTextInputChanged() {
        let isFormValid = emailLogin.text?.count ?? 0 > 0 && passwordLogin.text?.count ?? 0 > 0
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 257)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    fileprivate func loginSetup() {
        let stackView = UIStackView(arrangedSubviews: [emailLogin, passwordLogin, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        view.addSubview(swichToSignUpButton)
        view.addSubview(logoView)
        swichToSignUpButton.constraints(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: -20, paddingLeft: 0, paddingRight: 0, width: 0, height: 40)
        logoView.constraints(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 200)
        stackView.constraints(top: logoView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 120, paddingBottom: 0, paddingLeft: 40, paddingRight: 40, width: 0, height: 140)
        
    }
    @objc func switchToSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
}
