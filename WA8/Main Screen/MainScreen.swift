//
//  MainScreen.swift
//  WA8
//
//  Created by 郭 on 2023/11/17.
//

import UIKit

class MainScreen: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var tableViewChatLists: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setupTableViewNotes()
        initConstraints()
    }
    

    func setupTableViewNotes(){
        tableViewChatLists = UITableView()
        tableViewChatLists.register(ContactsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewContactsID)
        tableViewChatLists.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewChatLists)
    }

    func initConstraints(){
        NSLayoutConstraint.activate([
            
            tableViewChatLists.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewChatLists.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewChatLists.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewChatLists.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
