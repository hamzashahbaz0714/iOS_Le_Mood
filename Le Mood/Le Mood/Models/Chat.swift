//
//  Chat.swift
//  Chat App
//
//  Created by Hamza Shahbaz on 09/05/2020.
//  Copyright © 2020 Hamza Shahbaz. All rights reserved.
//

import Foundation

class Chat{
    public var chatId:String
    public var lastMessage:String
    public var lastMessageDate:String
    public var messageType: String = ""
    public var lastMessageTime:Int
    public var sender:String
    public var receiver:String
    public var otherUser:String = ""
    public var notReadBy = [String]()
    
    init(chatId:String,lastMessage:String,lastMessageDate:String,lastMessageTime:Int,sender:String,receiver:String,notReadBy:[String]) {
        self.chatId = chatId
        self.lastMessage = lastMessage
        self.lastMessageTime = lastMessageTime
        self.lastMessageDate = lastMessageDate
        self.sender = sender
        self.receiver = receiver
        self.notReadBy = notReadBy
    }
}
