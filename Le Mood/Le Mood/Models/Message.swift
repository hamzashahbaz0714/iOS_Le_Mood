//
//  Message.swift
//  Chat App
//
//  Created by Hamza Shahbaz on 09/05/2020.
//  Copyright © 2020 Hamza Shahbaz. All rights reserved.
//

import Foundation

class Message{
    private(set) var messageId:String
    public var reciverId:String
    public var senderId:String
    public var messageBody:String
    public var messageType:String
    public var messageTime:Int
    public var messageDate:String
    public var isIncoming:Bool
    
    init(messageId:String,reciverId:String,senderId:String,messageBody:String,messageType:String,messageTime:Int,messageDate:String,isIncoming:Bool) {
        self.messageBody = messageBody
        self.messageDate = messageDate
        self.messageId = messageId
        self.messageTime = messageTime
        self.reciverId = reciverId
        self.senderId = senderId
        self.isIncoming = isIncoming
        self.messageType = messageType
    }
}
