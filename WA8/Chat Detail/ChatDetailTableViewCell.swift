//
//  ChatDetailTableViewCell.swift
//  WA8
//
//  Created by 郭 on 2023/11/20.
//

import UIKit

class ChatDetailTableViewCell: UITableViewCell {

        var wrapperCellView: UIView!
        var labelMessage: UILabel!
        var labelTime: UILabel!
        var labelSenderName: UILabel!

        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            setupWrapperCellView()
            setupLabelMessage()
            setupLabelTime()
            setupLabelSenderName()
            
            initConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupWrapperCellView(){
            wrapperCellView = UIView() 
            
            //working with the shadows and colors...
            wrapperCellView.backgroundColor = .white
            wrapperCellView.layer.cornerRadius = 6.0
            wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
            wrapperCellView.layer.shadowOffset = .zero
            wrapperCellView.layer.shadowRadius = 4.0
            wrapperCellView.layer.shadowOpacity = 0.4
            wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(wrapperCellView)
        }
        
        
    func setupLabelSenderName(){
        labelSenderName = UILabel()
        labelSenderName.font = UIFont.boldSystemFont(ofSize: 12)
        labelSenderName.translatesAutoresizingMaskIntoConstraints = false
//        labelSenderName.addSubview(labelSenderName)
        wrapperCellView.addSubview(labelSenderName)
    }
    
        func setupLabelMessage(){
            labelMessage = UILabel()
            labelMessage.font = UIFont.boldSystemFont(ofSize: 20)
            labelMessage.translatesAutoresizingMaskIntoConstraints = false
            wrapperCellView.addSubview(labelMessage)
        }
        
        func setupLabelTime(){
            labelTime = UILabel()
            labelTime.font = UIFont.boldSystemFont(ofSize: 12)
            labelTime.translatesAutoresizingMaskIntoConstraints = false
            wrapperCellView.addSubview(labelTime)
        }
        

        
//        func initConstraints(){
//            NSLayoutConstraint.activate([
//
//                wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
//                wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//                wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
//                wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//
//
//                labelSenderName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 12),
//                labelSenderName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
//                labelSenderName.heightAnchor.constraint(equalToConstant: 20),
//                labelSenderName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
//
//
//                labelMessage.topAnchor.constraint(equalTo: labelSenderName.bottomAnchor, constant: 12),
//                       labelMessage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16), // Changed to wrapperCellView.leadingAnchor
//                labelMessage.heightAnchor.constraint(equalToConstant: 20),
//                labelMessage.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
//
//
//                labelTime.topAnchor.constraint(equalTo: labelMessage.bottomAnchor, constant: 10),
//                labelTime.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
//                labelTime.heightAnchor.constraint(equalToConstant: 16),
//                labelTime.widthAnchor.constraint(lessThanOrEqualTo: labelMessage.widthAnchor),
//
//
//
//
//                wrapperCellView.heightAnchor.constraint(equalToConstant: 92)
//            ])
//        }

    func initConstraints() {
        NSLayoutConstraint.activate([
            // wrapperCellView constraints
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            // labelMessage constraints
            labelMessage.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 12),
            labelMessage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelMessage.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            labelMessage.heightAnchor.constraint(equalToConstant: 20),
            
            // labelTime constraints
            labelTime.topAnchor.constraint(equalTo: labelMessage.bottomAnchor, constant: 10),
            labelTime.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelTime.heightAnchor.constraint(equalToConstant: 16),
            
            // labelSenderName constraints
            labelSenderName.topAnchor.constraint(equalTo: labelMessage.bottomAnchor, constant: 10),
            labelSenderName.leadingAnchor.constraint(equalTo: labelTime.trailingAnchor, constant: 10), // Adjust based on your layout
            labelSenderName.heightAnchor.constraint(equalToConstant: 16),
            labelSenderName.trailingAnchor.constraint(lessThanOrEqualTo: wrapperCellView.trailingAnchor, constant: -16),

            // Adjusting the height of wrapperCellView if necessary
            wrapperCellView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70) // Adjust based on content
        ])
    }

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }



