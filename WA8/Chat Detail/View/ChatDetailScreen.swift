//
//  ChatDetailScreen.swift
//  WA8
//
//  Created by 郭 on 2023/11/17.
//

import UIKit

class ChatDetailScreen: UIView {

    var contentWrapper:UIScrollView!
    var bottomAddView:UIView!
    var textField:UITextView!
    var buttonSent:UIButton!
    
    var chatDetailTable: UITableView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
 
        setupContentWrapper()
        setupBottomAddView()
        setupTextField()
        setupButtonSent()
        setupTableViewNotes() 

        initConstraints()
    }
    
    func setupBottomAddView(){
        bottomAddView = UIView()
        bottomAddView.backgroundColor = .white
        bottomAddView.layer.cornerRadius = 10
        bottomAddView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomAddView.layer.shadowOffset = .zero
        bottomAddView.layer.shadowRadius = 4.0
        bottomAddView.layer.shadowOpacity = 0.7
        bottomAddView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomAddView)
    }
    func setupTextField(){
        textField = UITextView(frame:CGRectMake(50, 50, 50, 50))
        textField.layer.cornerRadius = 10
        textField.layer.backgroundColor = UIColor.lightGray.cgColor
        textField.text = ""
        textField.font = UIFont.systemFont(ofSize:18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(textField)
    }

    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupTableViewNotes(){
        chatDetailTable = UITableView()
        chatDetailTable.register(ChatDetailTableViewCell.self, forCellReuseIdentifier: Configs.ChatDetailTableViewID)
        chatDetailTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chatDetailTable)
    }

    func setupButtonSent(){
        buttonSent = UIButton(type: .system)
        buttonSent.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonSent.setTitle("Sent Message", for: .normal)
        buttonSent.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(buttonSent)
    }
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            chatDetailTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            chatDetailTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            chatDetailTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            chatDetailTable.bottomAnchor.constraint(equalTo: bottomAddView.topAnchor),
            
            bottomAddView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -8),
            bottomAddView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bottomAddView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            buttonSent.bottomAnchor.constraint(equalTo: bottomAddView.bottomAnchor, constant: -8),
            buttonSent.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 4),
            buttonSent.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -4),
            
            textField.bottomAnchor.constraint(equalTo: buttonSent.topAnchor, constant: -8),
            textField.leadingAnchor.constraint(equalTo: buttonSent.leadingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: buttonSent.trailingAnchor, constant: -4),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            bottomAddView.topAnchor.constraint(equalTo: textField.topAnchor, constant: -8),
            
         
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
