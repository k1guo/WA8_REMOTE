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
        buttonLogin = UIButton(type: .system)
        buttonLogin.setTitle("Login", for: .normal)
        buttonLogin.titleLabel?.font = .boldSystemFont(ofSize: 21)
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonLogin)
    }
    func setupButtonSignup(){
        buttonSignup = UIButton(type: .system)
        buttonSignup.setTitle("Sign Up", for: .normal)
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
            
            buttonLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor,constant: 43),
            buttonLogin.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            registerLabel.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor,constant: 52),
            registerLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 58),
            
            buttonSignup.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor,constant: 46),
            buttonSignup.leadingAnchor.constraint(equalTo: registerLabel.trailingAnchor,constant: 15)
            
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
