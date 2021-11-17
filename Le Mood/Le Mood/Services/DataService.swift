//
//  DataService.swift
//  Le Mood
//
//  Created by MAC on 30/07/2021.
//


import Foundation
import FirebaseFirestore
import Firebase

class DataService{
    static let instance = DataService()
    
    let userReference = Firestore.firestore().collection("users")
    let patientReference = Firestore.firestore().collection("Patients")
    let chatReference = Firestore.firestore().collection("chats")
    let randomchatReference = Firestore.firestore().collection("randomChats")
    
    
    var currentUser : UserModel!
    
    func setCurrentUser(user:UserModel){
        self.currentUser = user
    }
    
    func emptyCurrentUser(){
        currentUser = nil
    }
    
    func updateUser(user:UserModel){
        userReference.document(user.id).setData([
            "id":user.id,
            "name":user.name,
            "email":user.email,
            "phoneNumber": user.phoneNumber,
            "image": user.image,
            "gender": user.gender,
            "country":user.country,
            "region": user.region,
            "createdAt": FieldValue.serverTimestamp(),
            "language": user.language,
            "nickName": user.nikName,
            "isMoodVisible": user.isMoodVisible
        ], merge: true) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err)")
            } else {
            }
        }
    }
    
    func getUserOfID(userID:String,handler: @escaping(_ success:Bool,_ user:UserModel?)->()){
        let userRef = userReference.document(userID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                let id = data["id"] as? String ?? "Not Found"
                let name = data["name"] as? String ?? "Not Found"
                let email = data["email"] as? String ?? "Not Found"
                let gender = data["gender"] as? String ?? "Not Found"
                let country = data["country"] as? String ?? "Not Found"
                let region = data["region"] as? String ?? "Not Found"
                let image = data["image"] as? String ?? "Not Found"
                let phoneNumber = data["phoneNumber"] as? String ?? "Not Found"
                let fcmToken = data["fcmToken"] as? String ?? "Not Found"
                let moodId = data["moodId"] as? String ?? "Not Found"
                let moodType = data["moodType"] as? String ?? "Not Found"
                let moodValue = data["moodValue"] as? Int ?? 0
                let lastMoodDate = data["lastMoodDate"] as? String ?? ""
                let language = data["language"] as? String ?? "Not Found"
                let nikName = data["nickName"] as? String ?? "Not Found"
                let isMoodVisible = data["isMoodVisible"] as? Bool ?? true
                
                let user = UserModel(id: id, name: name, nikName: nikName, email: email, phoneNumber: phoneNumber, image: image, gender: gender, country: country, region: region,moodId: moodId,moodType: moodType,moodValue: moodValue,lastMoodDate: lastMoodDate,fcmToken: fcmToken, language: language, isMoodVisible: isMoodVisible)
                handler(true,user)
                
            } else {
                handler(false,nil)
                print("Document does not exist")
            }
        }
    }
    
    func saveAndEditMood(mood: MoodModel,docId: String){
        userReference.document(Auth.auth().currentUser!.uid).collection("moods").document(docId).setData([
            "moodId":docId,
            "moodType":mood.moodType,
            "moodValue":mood.moodValue,
            "time": mood.time,
            "date": mood.date,
            "country": mood.country,
            "state": mood.state,
            "createdAt": FieldValue.serverTimestamp()
        ], merge: true) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err)")
            } else {
                self.userReference.document(Auth.auth().currentUser!.uid).setData([
                    "moodId":mood.moodId,
                    "moodType":mood.moodType,
                    "moodValue":mood.moodValue,
                    "lastMoodDate":getCurrentDate()
                ], merge: true) { (err) in
                    if let err = err {
                        debugPrint("Error adding document: \(err)")
                    } else {
                    }
                }
            }
        }
    }
    
    func saveMoodByDate(mood: MoodModel,docId: String, moodId: String){
        
        Firestore.firestore().collection("allMoods").document(docId).collection("moods").document(moodId).setData([
            "moodId":mood.moodId,
            "moodType":mood.moodType,
            "moodValue":mood.moodValue,
            "time": mood.time,
            "date": mood.date,
            "country": mood.country,
            "state": mood.state,
            "createdAt": FieldValue.serverTimestamp()
        ], merge: true) { (err) in
            
        }
    }
    
    
    func getAllFriends(handler: @escaping(_ success:Bool,_ allUser:[UserModel]?)->()){
        var userArray  = [UserModel]()
        userReference.getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                let data = document.data()
                let id = data["id"] as? String ?? "Not Found"
                let name = data["name"] as? String ?? "Not Found"
                let email = data["email"] as? String ?? "Not Found"
                let gender = data["gender"] as? String ?? "Not Found"
                let country = data["country"] as? String ?? "Not Found"
                let region = data["region"] as? String ?? "Not Found"
                let image = data["image"] as? String ?? "Not Found"
                let phoneNumber = data["phoneNumber"] as? String ?? "Not Found"
                let fcmToken = data["fcmToken"] as? String ?? "Not Found"
                let moodId = data["moodId"] as? String ?? "Not Found"
                let moodType = data["moodType"] as? String ?? "Not Found"
                let moodValue = data["moodValue"] as? Int ?? 0
                let lastMoodDate = data["moodType"] as? String ?? "Not Found"
                let language = data["language"] as? String ?? "Not Found"
                let nikName = data["nickName"] as? String ?? "Not Found"
                let isMoodVisible = data["isMoodVisible"] as? Bool ?? true

                
                
                if id != Auth.auth().currentUser?.uid {
                    let user = UserModel(id: id, name: name, nikName: nikName, email: email, phoneNumber: phoneNumber, image: image, gender: gender, country: country, region: region,moodId: moodId,moodType: moodType,moodValue: moodValue,lastMoodDate: lastMoodDate,fcmToken: fcmToken, language: language, isMoodVisible: isMoodVisible)
                    user.fcmToken = fcmToken
                    userArray.append(user)
                }
                
            }
            handler(true,userArray)
        }
    }
    
    func searchLanguageBaseFriend(language: [String],handler: @escaping(_ success:Bool,_ allUser:[UserModel]?)->()){
        var userArray  = [UserModel]()
        userReference.whereField("language", in: language).getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                let data = document.data()
                let id = data["id"] as? String ?? "Not Found"
                let name = data["name"] as? String ?? "Not Found"
                let email = data["email"] as? String ?? "Not Found"
                let gender = data["gender"] as? String ?? "Not Found"
                let country = data["country"] as? String ?? "Not Found"
                let region = data["region"] as? String ?? "Not Found"
                let image = data["image"] as? String ?? "Not Found"
                let phoneNumber = data["phoneNumber"] as? String ?? "Not Found"
                let fcmToken = data["fcmToken"] as? String ?? "Not Found"
                let moodId = data["moodId"] as? String ?? "Not Found"
                let moodType = data["moodType"] as? String ?? "Not Found"
                let moodValue = data["moodValue"] as? Int ?? 0
                let lastMoodDate = data["moodType"] as? String ?? "Not Found"
                let language = data["language"] as? String ?? "Not Found"
                let nikName = data["nickName"] as? String ?? "Not Found"
                let isMoodVisible = data["isMoodVisible"] as? Bool ?? true

                
                
                if id != Auth.auth().currentUser?.uid {
                    let user = UserModel(id: id, name: name, nikName: nikName, email: email, phoneNumber: phoneNumber, image: image, gender: gender, country: country, region: region,moodId: moodId,moodType: moodType,moodValue: moodValue,lastMoodDate: lastMoodDate,fcmToken: fcmToken, language: language, isMoodVisible: isMoodVisible)
                    user.fcmToken = fcmToken
                    userArray.append(user)
                }
                
            }
            handler(true,userArray)
        }
    }
    
    func getMoodByDate(handler: @escaping(_ success:Bool,_ mood:MoodModel?)->()){
        let userRef = userReference.document(Auth.auth().currentUser!.uid).collection("moods").whereField("date", in: [getCurrentDate()])
        userRef.getDocuments(completion: { (snapshot, error) in
            if snapshot?.documents.count  ?? 0 > 0 {
                for document in snapshot!.documents {
                    if document == document {
                        let data = document.data()
                        let moodId = data["moodId"] as? String ?? "Not Found"
                        let moodType = data["moodType"] as? String ?? "Not Found"
                        let moodValue = data["moodValue"] as? Int ?? 0
                        let time = data["time"] as? String ?? "Not Found"
                        let date = data["date"] as? String ?? "Not Found"
                        let country = data["country"] as? String ?? "Not Found"
                        let state = data["state"] as? String ?? "Not Found"
                        
                        let mood = MoodModel(moodId: moodId, moodType: moodType, moodValue: moodValue, time: time, date: date,country: country,state: state)
                        handler(true,mood)
                        break
                    }
                    else
                    {
                        handler(false,nil)
                    }
                }
            }
            else
            {
                handler(false,nil)
                
            }
        })
        
    }
    
    func getMoodStatistics(handler: @escaping(_ success:Bool,_ mood:[MoodModel]?, _ country:[String]?)->()){
        let userRef = Firestore.firestore().collection("allMoods").document(getCurrentDateWithDash()).collection("moods")
        userRef.getDocuments(completion: { (snapshot, error) in
            if snapshot?.documents.count  ?? 0 > 0 {
                var moodArr = [MoodModel]()
                var countries = [String]()
                for document in snapshot!.documents {
                    if document == document {
                        let data = document.data()
                        let moodId = data["moodId"] as? String ?? "Not Found"
                        let moodType = data["moodType"] as? String ?? "Not Found"
                        let moodValue = data["moodValue"] as? Int ?? 0
                        let time = data["time"] as? String ?? "Not Found"
                        let date = data["date"] as? String ?? "Not Found"
                        let country = data["country"] as? String ?? "Not Found"
                        let state = data["state"] as? String ?? "Not Found"
                        
                        let mood = MoodModel(moodId: moodId, moodType: moodType, moodValue: moodValue, time: time, date: date,country: country,state: state)
                        moodArr.append(mood)
                        countries.append(country)
                    }
                    else
                    {
                        handler(false,nil, nil)
                    }
                    handler(true,moodArr,countries)
                }
            }
            else
            {
                handler(false,nil, nil)
                
            }
        })
        
    }
    
    
    func uploadProfilePicture(image:UIImage, handler :@escaping(_ success:Bool,_ picUrl:String)->()){
        var downloadLink = ""
        let imageData = image.jpegData(compressionQuality: 0.8)
        let storageRef = Storage.storage().reference().child("Profile Pics").child(("\(Auth.auth().currentUser?.uid ?? "").jpg"))
        _ = storageRef.putData(imageData!, metadata: nil) { (metaData, error) in
            print("upload task finished")
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil
                {
                    print(error!)
                    handler(false, "")
                }
                else
                {
                    downloadLink = (url?.absoluteString)!
                    
                    
                    handler(true,downloadLink)
                }
            })
        }
    }
    
    func getAllChats(handler:@escaping(_ chats:[Chat])->()){
        var chatsArray = [Chat]()
        chatReference.order(by: "createdAt", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                handler(chatsArray)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let chatId = data["chatId"] as? String ?? "Not Found"
                    let lastMessage = data["message"] as? String ?? "Not Found"
                    let lastMessageDate = data["messageDate"] as? String ?? "Not Found"
                    let lastMessageTime = data["messageTime"] as? Int ?? 0
                    let sender = data["sender"] as? String ?? "Not Found"
                    let receiver = data["receiver"] as? String ?? ""
                    let notReadBy = data["notReadBy"] as? [String] ?? [String]()
                    let messageType = data["messageType"] as? String ?? ""
                    
                    let chat = Chat(chatId: chatId, lastMessage: lastMessage, lastMessageDate: lastMessageDate, lastMessageTime: lastMessageTime, sender: sender, receiver: receiver,notReadBy: notReadBy)
                    chat.messageType = messageType
                    if chat.chatId.contains(Auth.auth().currentUser!.uid){
                        print("coming here")
                        let rID = chat.chatId.replacingOccurrences(of: Auth.auth().currentUser!.uid, with: "")
                        chat.otherUser = rID
                        chatsArray.append(chat)
                    }
                    
                    
                }
                handler(chatsArray)
            }
        }
    }
    func getRandomAllChats(handler:@escaping(_ chats:[Chat])->()){
        var chatsArray = [Chat]()
        randomchatReference.order(by: "createdAt", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                handler(chatsArray)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let chatId = data["chatId"] as? String ?? "Not Found"
                    let lastMessage = data["message"] as? String ?? "Not Found"
                    let lastMessageDate = data["messageDate"] as? String ?? "Not Found"
                    let lastMessageTime = data["messageTime"] as? Int ?? 0
                    let sender = data["sender"] as? String ?? "Not Found"
                    let receiver = data["receiver"] as? String ?? ""
                    let notReadBy = data["notReadBy"] as? [String] ?? [String]()
                    let messageType = data["messageType"] as? String ?? ""
                    
                    let chat = Chat(chatId: chatId, lastMessage: lastMessage, lastMessageDate: lastMessageDate, lastMessageTime: lastMessageTime, sender: sender, receiver: receiver,notReadBy: notReadBy)
                    chat.messageType = messageType
                    if chat.chatId.contains(Auth.auth().currentUser!.uid){
                        print("coming here")
                        let rID = chat.chatId.replacingOccurrences(of: Auth.auth().currentUser!.uid, with: "")
                        chat.otherUser = rID
                        chatsArray.append(chat)
                    }
                    
                    
                }
                handler(chatsArray)
            }
        }
    }
    
    
    func getChatOfID(isComeFromRandomORChat:Bool,chatID:String,handler:@escaping(_ success:Bool,_ chat:Chat?) -> ()){
        if isComeFromRandomORChat == false {
        let chatRef = chatReference.document(chatID)
        chatRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                let chatId = data["chatId"] as? String ?? "Not Found"
                let lastMessage = data["message"] as? String ?? "Not Found"
                let lastMessageDate = data["messageDate"] as? String ?? "Not Found"
                let lastMessageTime = data["messageTime"] as? Int ?? 0
                let sender = data["sender"] as? String ?? "Not Found"
                let receiver = data["receiver"] as? String ?? ""
                let notReadBy = data["notReadBy"] as? [String] ?? [String]()
                
                let chat = Chat(chatId: chatId, lastMessage: lastMessage, lastMessageDate: lastMessageDate, lastMessageTime: lastMessageTime, sender: sender, receiver: receiver,notReadBy: notReadBy)
                handler(true,chat)
                
            } else {
                handler(false,nil)
                print("Document does not exist")
            }
        }
        }
        else
        {
            let chatRef = randomchatReference.document(chatID)
            chatRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()!
                    let chatId = data["chatId"] as? String ?? "Not Found"
                    let lastMessage = data["message"] as? String ?? "Not Found"
                    let lastMessageDate = data["messageDate"] as? String ?? "Not Found"
                    let lastMessageTime = data["messageTime"] as? Int ?? 0
                    let sender = data["sender"] as? String ?? "Not Found"
                    let receiver = data["receiver"] as? String ?? ""
                    let notReadBy = data["notReadBy"] as? [String] ?? [String]()
                    
                    let chat = Chat(chatId: chatId, lastMessage: lastMessage, lastMessageDate: lastMessageDate, lastMessageTime: lastMessageTime, sender: sender, receiver: receiver,notReadBy: notReadBy)
                    handler(true,chat)
                    
                } else {
                    handler(false,nil)
                    print("Document does not exist")
                }
            }
        }
    }
    func updateChatNotRead(isComeFromRandomORChat:Bool,chatID:String,notReadBy:[String]){
        if isComeFromRandomORChat == false {
            self.chatReference.document(chatID).setData([
                "notReadBy":notReadBy,
            ], merge: true) { (err) in
                if let err = err {
                    debugPrint("Error adding document: \(err)")
                } else {
                }
            }
        }
        else
        {
            self.randomchatReference.document(chatID).setData([
                "notReadBy":notReadBy,
            ], merge: true) { (err) in
                if let err = err {
                    debugPrint("Error adding document: \(err)")
                } else {
                }
            }
        }
    }
    
    func addChatMessage(isComefromRandomORMyCHat: Bool?,chatID:String,message:Message,notReadBy:[String],senderName: String,senderImage: String){
        if isComefromRandomORMyCHat == false {
            chatReference.document(chatID).collection("messages").document(message.messageId).setData([
                "isIncoming":message.isIncoming,
                "message":message.messageBody,
                "messageDate":message.messageDate,
                "messageId":message.messageId,
                "messageTime":message.messageTime,
                "messageType":message.messageType,
                "receiverId":message.reciverId,
                "senderId":message.senderId,
                "createdAt": FieldValue.serverTimestamp()
            ], merge: true) { (err) in
                if let err = err {
                    debugPrint("Error adding document: \(err)")
                } else {
                    self.chatReference.document(chatID).setData([
                        "chatId":chatID,
                        "senderId":message.senderId,
                        "receiverId":message.reciverId,
                        "message":message.messageBody,
                        "messageDate":message.messageDate,
                        "messageTime":message.messageTime,
                        "createdAt":FieldValue.serverTimestamp(),
                        "messageType": message.messageType,
                        "notReadBy":notReadBy,
                        "senderName":senderName,
                        "senderImage":senderImage,
                        "listnerId": [message.senderId,message.reciverId]
                    ], merge: true) { (err) in
                        if let err = err {
                            debugPrint("Error adding document: \(err)")
                        } else {
                        }
                    }
                }
            }
        }
        else
        {
            Firestore.firestore().collection("randomChats").document(chatID).collection("messages").document(message.messageId).setData([
                "isIncoming":message.isIncoming,
                "message":message.messageBody,
                "messageDate":message.messageDate,
                "messageId":message.messageId,
                "messageTime":message.messageTime,
                "messageType":message.messageType,
                "receiverId":message.reciverId,
                "senderId":message.senderId,
                "createdAt": FieldValue.serverTimestamp()
            ], merge: true) { (err) in
                if let err = err {
                    debugPrint("Error adding document: \(err)")
                } else {
                    self.randomchatReference.document(chatID).setData([
                        "chatId":chatID,
                        "senderId":message.senderId,
                        "receiverId":message.reciverId,
                        "message":message.messageBody,
                        "messageDate":message.messageDate,
                        "messageTime":message.messageTime,
                        "createdAt":FieldValue.serverTimestamp(),
                        "messageType": message.messageType,
                        "notReadBy":notReadBy,
                        "senderName":senderName,
                        "senderImage":senderImage,
                        "listnerId": [message.senderId,message.reciverId]
                    ], merge: true) { (err) in
                        if let err = err {
                            debugPrint("Error adding document: \(err)")
                        } else {
                        }
                    }
                }
            }
            
        }
    }
    
    func getAllChatMessages(chatID:String,handler:@escaping(_ success:Bool,_ messages:[Message])->()){
        var messageArray = [Message]()
        chatReference.document(chatID).collection("messages").order(by: "createdAt", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                //handler(messageArray)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let messageId = data["messageId"] as? String ?? "Not Found"
                    let reciverId = data["receiverId"] as? String ?? "Not Found"
                    let senderId = data["senderId"] as? String ?? "Not Found"
                    let messageBody = data["message"] as? String ?? "Not Found"
                    let messageType = data["messageType"] as? String ?? "Not Found"
                    let messageTime = data["messageTime"] as? Int ?? 0
                    let messageDate = data["messageDate"] as? String ?? ""
                    
                    let message = Message(messageId: messageId, reciverId: reciverId, senderId: senderId, messageBody: messageBody, messageType: messageType, messageTime: messageTime, messageDate: messageDate, isIncoming: false)
                    if senderId != Auth.auth().currentUser?.uid{
                        message.isIncoming = true
                        messageArray.append(message)
                    }else{
                        message.isIncoming = false
                        messageArray.append(message)
                    }
                    
                }
                handler(true,messageArray)
            }
        }
    }
    func getRandomChatMessages(chatID:String,handler:@escaping(_ success:Bool,_ messages:[Message])->()){
        var messageArray = [Message]()
        randomchatReference.document(chatID).collection("messages").order(by: "createdAt", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                //handler(messageArray)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let messageId = data["messageId"] as? String ?? "Not Found"
                    let reciverId = data["receiverId"] as? String ?? "Not Found"
                    let senderId = data["senderId"] as? String ?? "Not Found"
                    let messageBody = data["message"] as? String ?? "Not Found"
                    let messageType = data["messageType"] as? String ?? "Not Found"
                    let messageTime = data["messageTime"] as? Int ?? 0
                    let messageDate = data["messageDate"] as? String ?? ""
                    
                    let message = Message(messageId: messageId, reciverId: reciverId, senderId: senderId, messageBody: messageBody, messageType: messageType, messageTime: messageTime, messageDate: messageDate, isIncoming: false)
                    if senderId != Auth.auth().currentUser?.uid{
                        message.isIncoming = true
                        messageArray.append(message)
                    }else{
                        message.isIncoming = false
                        messageArray.append(message)
                    }
                    
                }
                handler(true,messageArray)
            }
        }
    }
    
    
    func uploadPIcture(image:UIImage,handler :@escaping(_ success:Bool,_ picUrl:String)->()){
        var downloadLink = ""
        let imageData = image.jpegData(compressionQuality: 0.7)
        let storageRef = Storage.storage().reference().child("iOS_App_Pics").child(("\(UUID().uuidString).jpg"))
        _ = storageRef.putData(imageData!, metadata: nil) { (metaData, error) in
            print("upload task finished")
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil
                {
                    print(error!)
                    handler(false, "")
                }
                else
                {
                    downloadLink = (url?.absoluteString) ?? ""
                    handler(true,downloadLink)
                }
            })
        }
    }
    func uploadVideos(videoURL:URL,handler :@escaping(_ success:Bool,_ picUrl:String)-> Void){
        var downloadLink = ""
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        
        if let videoData = NSData(contentsOf: videoURL) as Data? {
            let storageRef = Storage.storage().reference().child("iOS_App_Video").child(("\(UUID().uuidString).mp4"))
            _ = storageRef.putData(videoData, metadata: metadata) { (metaData, err) in
                print("upload task finished")
                if let err = err {
                    print("Failed to upload movie:", err)
                    handler(false,downloadLink)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Failed to get download url:", err)
                        handler(false,downloadLink)
                        return
                        
                    }
                    else
                    {
                        downloadLink = (url?.absoluteString) ?? ""
                        handler(true,downloadLink)
                    }
                })
            }
            
        }
    }
    
    func uploadGifs(selectedGif:URL,handler :@escaping(_ success:Bool,_ picUrl:String)-> Void){
        var downloadLink = ""
        let metadata = StorageMetadata()
        metadata.contentType = "image/gif"
        
        if let videoData = NSData(contentsOf: selectedGif) as Data? {
            let storageRef = Storage.storage().reference().child("iOS_App_Pics").child(("\(UUID().uuidString).gif"))
            _ = storageRef.putData(videoData, metadata: metadata) { (metaData, err) in
                print("upload task finished")
                if let err = err {
                    print("Failed to upload movie:", err)
                    handler(false,downloadLink)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Failed to get download url:", err)
                        handler(false,downloadLink)
                        return
                        
                    }
                    else
                    {
                        downloadLink = (url?.absoluteString) ?? ""
                        handler(true,downloadLink)
                    }
                })
            }
            
        }
    }
    
    func getCountries(){
        let ref = Database.database().reference().child("le-mood-50649-default-rtdb").root
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                print(objects)
                if !snapshot.exists() { return }
                print(snapshot) // Its print all values including Snap (User)
                print(snapshot.value!)
                if let tempDic : Dictionary = snapshot.value as? Dictionary<String,Any>
                {
                    
                    if let name = tempDic["name"] as? String {
                        
                        print(name)
                    }
                }
            }
        })
    }
    func loadCountriesAndStates(handler:@escaping(_ success:Bool,_ country:CountriesStatesModel?)->()) {
        let url = Bundle.main.url(forResource: "CountriesStatesList", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try! JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String,AnyObject>
            print(json)
            let decoder = JSONDecoder()
            let data = try decoder.decode(CountriesStatesModel.self, from: jsonData)
            handler(true,data)
        }
        catch {
            handler(false,nil)
            print(error)
        }
        
    }
    
}
