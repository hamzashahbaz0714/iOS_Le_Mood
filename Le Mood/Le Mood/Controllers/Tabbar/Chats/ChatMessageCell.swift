//
//  ChatMessageCell.swift
//  Wind Searched
//
//  Created by Hamza Shahbaz on 7/01/20.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {

    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    var chatMessage: Message! {
        didSet {
            bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? .white : #colorLiteral(red: 0.5527641773, green: 0.7810578942, blue: 0.9601557851, alpha: 1)
            bubbleBackgroundView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7715111301)
            bubbleBackgroundView.layer.shadowOpacity = 0.2
            bubbleBackgroundView.layer.shadowOffset = .zero
            bubbleBackgroundView.layer.shadowRadius = 4
            messageLabel.textColor = chatMessage.isIncoming ? .black : .white
            
            if chatMessage.isIncoming{
                let attributedText = NSMutableAttributedString(string: "\(chatMessage.messageBody)", attributes: [.font: UIFont(name: "Poppins-Medium", size: 17)!])
                
                attributedText.append(NSAttributedString(string: "\n\(chatMessage.messageDate)", attributes: [.font: UIFont(name: "Poppins-Medium", size: 12)!]))
                
                messageLabel.attributedText = attributedText
                
            }else{
                let attributedText = NSMutableAttributedString(string: "\(chatMessage.messageBody)", attributes: [.font: UIFont(name: "Poppins-Medium", size: 17)!])
                
                attributedText.append(NSAttributedString(string: "\n\(chatMessage.messageDate)", attributes: [.font: UIFont(name: "Poppins-Medium", size: 12)!]))
                
                messageLabel.attributedText = attributedText
            }
           
            
            
            
            if chatMessage.isIncoming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = .yellow
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        
        // lets set up some constraints for our label
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}






