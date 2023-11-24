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
    var labelText: UILabel!
    var currentUserPic: UIImageView!
    var tableViewChatLists: UITableView!
    var floatingButtonSetting: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setupLabelText()
        setupTableViewNotes()
        setupCurrentUserPic()
        setupFloatingButtonSetting()
        initConstraints()
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = .boldSystemFont(ofSize: 18)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupCurrentUserPic(){
        currentUserPic = UIImageView()
        currentUserPic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        currentUserPic.contentMode = .scaleAspectFill
        currentUserPic.clipsToBounds = true
        currentUserPic.layer.masksToBounds = true
        currentUserPic.layer.cornerRadius = 16.0
        currentUserPic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(currentUserPic)
    }

    func setupTableViewNotes(){
        tableViewChatLists = UITableView()
        tableViewChatLists.register(ContactsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewContactsID)
        tableViewChatLists.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewChatLists)
    }
    
    func setupFloatingButtonSetting(){
        floatingButtonSetting = UIButton(type: .system)
        floatingButtonSetting.setTitle("", for: .normal)
        floatingButtonSetting.setImage(UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        floatingButtonSetting.contentHorizontalAlignment = .fill
        floatingButtonSetting.contentVerticalAlignment = .fill
        floatingButtonSetting.imageView?.contentMode = .scaleAspectFit
        floatingButtonSetting.layer.cornerRadius = 16
        floatingButtonSetting.imageView?.layer.shadowOffset = .zero
        floatingButtonSetting.imageView?.layer.shadowRadius = 0.8
        floatingButtonSetting.imageView?.layer.shadowOpacity = 0.7
        floatingButtonSetting.imageView?.clipsToBounds = true
        floatingButtonSetting.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(floatingButtonSetting)
    }

    func initConstraints(){
        NSLayoutConstraint.activate([
            currentUserPic.widthAnchor.constraint(equalToConstant: 32),
            currentUserPic.heightAnchor.constraint(equalToConstant: 32),
            currentUserPic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 18),
            currentUserPic.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 22),
            
            labelText.topAnchor.constraint(equalTo: currentUserPic.topAnchor),
            labelText.bottomAnchor.constraint(equalTo: currentUserPic.bottomAnchor),
            labelText.leadingAnchor.constraint(equalTo: currentUserPic.trailingAnchor, constant: 8),
            
            tableViewChatLists.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 8),
            tableViewChatLists.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewChatLists.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableViewChatLists.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -8),
            
            floatingButtonSetting.widthAnchor.constraint(equalToConstant: 48),
            floatingButtonSetting.heightAnchor.constraint(equalToConstant: 48),
            floatingButtonSetting.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingButtonSetting.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
