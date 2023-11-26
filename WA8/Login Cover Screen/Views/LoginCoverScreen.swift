//
//  LoginView.swift
//  WA8
//
//  Created by 郭 on 2023/11/14.
//

import UIKit

class LoginCoverScreen: UIView {

    var titleNotes:UILabel!
    var labelUserName:UILabel!
    var labelPassword:UILabel!
    var textFieldName:UITextField!
    var textFieldPassword:UITextField!
    var registerLabel:UILabel!
    var buttonLogin:UIButton!
    var buttonSignup:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTitleNotes()
        setupLabelUserName()
        setupLabelPassword()
        setupTextFieldName()
        setupTextFieldPassword()
        setupRegisterLabel()
        setupButtonLogin()
        setupButtonSignup()
        
        initConstraints()
    }
    func setupTitleNotes(){
        titleNotes = UILabel()
        titleNotes.text = "Let's Chat"
        titleNotes.font = UIFont.boldSystemFont(ofSize: 35)
        titleNotes.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleNotes)
    }
    func setupLabelUserName(){
        labelUserName = UILabel()
        labelUserName.text = "Email"
        labelUserName.font = UIFont.boldSystemFont(ofSize: 16)
        labelUserName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelUserName)

    }
    func setupLabelPassword(){
        labelPassword = UILabel()
        labelPassword.text = "Password"
        labelPassword.font = UIFont.boldSystemFont(ofSize: 16)
        labelPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPassword)
    }
    func setupTextFieldName(){
        textFieldName = UITextField()
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }
    func setupTextFieldPassword(){
        textFieldPassword = UITextField()
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldPassword)
    }
    func setupRegisterLabel(){
        registerLabel = UILabel()
        registerLabel.text = "Haven't have a account? "
        registerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(registerLabel)
    }
    func setupButtonLogin(){
        buttonLogin = UIButton()
        buttonLogin.setTitle("Login", for: .normal)
        buttonLogin.titleLabel?.font = .boldSystemFont(ofSize: 19)
        buttonLogin.setTitleColor(.white, for: .normal)
        buttonLogin.backgroundColor = UIColor.systemBlue
        buttonLogin.layer.cornerRadius = 5
        buttonLogin.clipsToBounds = true
        buttonLogin.layer.shadowColor = UIColor.black.cgColor
        buttonLogin.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonLogin.layer.shadowRadius = 4
        buttonLogin.layer.shadowOpacity = 0.25
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonLogin)
    }
    func setupButtonSignup(){
        buttonSignup = UIButton()
        buttonSignup.setTitle("Sign Up", for: .normal)
        buttonSignup.titleLabel?.font = .systemFont(ofSize: 16)
        buttonSignup.setTitleColor(.white, for: .normal)
        buttonSignup.backgroundColor = UIColor.systemBlue
        buttonSignup.layer.cornerRadius = 3
        buttonSignup.clipsToBounds = true
        buttonSignup.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSignup)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            titleNotes.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 32),
            titleNotes.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            labelUserName.topAnchor.constraint(equalTo: titleNotes.bottomAnchor,constant: 42),
            labelUserName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            
            textFieldName.topAnchor.constraint(equalTo: labelUserName.bottomAnchor),
            textFieldName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            textFieldName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            
            labelPassword.topAnchor.constraint(equalTo: textFieldName.bottomAnchor,constant: 26),
            labelPassword.leadingAnchor.constraint(equalTo: labelUserName.leadingAnchor),
            
            textFieldPassword.topAnchor.constraint(equalTo: labelPassword.bottomAnchor),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            
            buttonLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor,constant: 50),
            buttonLogin.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            buttonLogin.widthAnchor.constraint(equalToConstant: 200),
            buttonLogin.heightAnchor.constraint(equalToConstant: 45),
            
            registerLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -30),
            registerLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 58),
            
            buttonSignup.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -38),
            buttonSignup.leadingAnchor.constraint(equalTo: registerLabel.trailingAnchor,constant: 15),
            buttonSignup.widthAnchor.constraint(equalToConstant: 100),
            buttonSignup.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
