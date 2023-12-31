//
//  ContactsTableViewCell.swift
//  WA8
//
//  Created by 郭 on 2023/11/15.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    var labelName: UILabel!
    var labelEmail: UILabel!
    var contactPhoto: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupLabelEmail()
        setupContactPhoto()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = UIColor.systemBackground
        wrapperCellView.layer.cornerRadius = 10.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = CGSize(width: 0, height: 2)
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.2
        
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelEmail(){
        labelEmail = UILabel()
        labelEmail.font = UIFont.boldSystemFont(ofSize: 14)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelEmail)
    }
    
    func setupContactPhoto(){
        contactPhoto = UIImageView()
        contactPhoto.contentMode = .scaleAspectFill // 设置内容模式
        contactPhoto.layer.cornerRadius = 5 // 设置圆角为 10 像素
        contactPhoto.clipsToBounds = true
        contactPhoto.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(contactPhoto)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            contactPhoto.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            contactPhoto.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            contactPhoto.widthAnchor.constraint(equalToConstant: 50),
            contactPhoto.heightAnchor.constraint(equalToConstant: 50),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 12),
            labelName.leadingAnchor.constraint(equalTo: contactPhoto.trailingAnchor, constant: 16),
            labelName.heightAnchor.constraint(equalToConstant: 20),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10),
            labelEmail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelEmail.heightAnchor.constraint(equalToConstant: 16),
            labelEmail.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
            

            wrapperCellView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
