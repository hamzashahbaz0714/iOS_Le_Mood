//
//  MessagesVC.swift
//  Wind Searched
//
//  Created by Hamza Shahbaz on 07/01/20.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD
import SDWebImage
import FirebaseFirestore
import Lightbox
import AVKit

var rID = ""

struct ChatMessage {
    let text: String
    let isIncoming: Bool
    let date: Date
}

extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
}

class MessagesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var lblChatRecieverName: UILabel!
    
    var player = AVPlayer()
    let playerViewController = AVPlayerViewController()
    var chatID:String?
    var notReadBy = [String]()
    
    var isEdited = false
    var messagesArray = [Message]()
    
    @IBOutlet weak var messageTxtView:UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtMessageHeight: NSLayoutConstraint!
    var passRecieverUser : UserModel?
    var isComeFromFirendsOrChatList = false
    var isComefromRandomORMyCHat = false
    var passName: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if isComeFromFirendsOrChatList == true {
            self.lblChatRecieverName.text = passName
        }
        else
        {
            lblChatRecieverName.text = passRecieverUser?.nikName
            imgView.sd_setImage(with: URL(string: passRecieverUser?.image ?? ""), placeholderImage: placeHolderImage, options: SDWebImageOptions.forceTransition)
        }
        //view.bindKeyboard()
        let tapGester = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGester)
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9764705882, blue: 1, alpha: 1)
        DataService.instance.getChatOfID(isComeFromRandomORChat: isComefromRandomORMyCHat, chatID: self.chatID!) { (success, returnedChat) in
            if success{
                if returnedChat!.notReadBy.contains(Auth.auth().currentUser!.uid){
                    if let index = returnedChat!.notReadBy.firstIndex(of: Auth.auth().currentUser!.uid){
                        returnedChat!.notReadBy.remove(at: index)
                        DataService.instance.updateChatNotRead(isComeFromRandomORChat: self.isComefromRandomORMyCHat, chatID: self.chatID!, notReadBy: returnedChat!.notReadBy)
                    }
                }
            }
        }
        
        
        DispatchQueue.main.async {
            if self.isComefromRandomORMyCHat == false {
                self.messagesArray.removeAll()
                let chatReference = Firestore.firestore().collection("chats").document(self.chatID!).collection("messages")
                chatReference.addSnapshotListener({ (snapShot, error) in
                    self.messagesArray.removeAll()
                    DataService.instance.getAllChatMessages(chatID: self.chatID!) { (success,returnedArray) in
                        if success{
                            self.messagesArray = returnedArray
                            self.tableView.reloadData()
                            if returnedArray.count > 0{
                                print("returnedArray.count \(returnedArray.count)")
                                self.tableView.scrollToBottom()
                            }
                        }
                    }
                })
            }
            else
            {
                self.messagesArray.removeAll()
                let chatReference = Firestore.firestore().collection("randomChats").document(self.chatID!).collection("messages")
                chatReference.addSnapshotListener({ (snapShot, error) in
                    self.messagesArray.removeAll()
                    DataService.instance.getRandomChatMessages(chatID: self.chatID!) { (success,returnedArray) in
                        if success{
                            self.messagesArray = returnedArray
                            self.tableView.reloadData()
                            if returnedArray.count > 0{
                                print("returnedArray.count \(returnedArray.count)")
                                self.tableView.scrollToBottom()
                            }
                        }
                    }
                })
            }
            
        }
        
    }
    
    func checkTimeStamp(date: String!) -> Bool {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let datecomponents = dateFormatter.date(from: date)
        
        let now = Date()
        
        if (datecomponents! >= now) {
            return true
        } else {
            return false
        }
    }
    func uploadPictureInFirebase(selectedImage: UIImage) {
        ProgressHUD.show()
        DataService.instance.uploadPIcture(image: selectedImage) { [weak self] (success, url) in
            if success {
                print(url)
                let message = Message(messageId: getUniqueId(), reciverId: rID, senderId: Auth.auth().currentUser!.uid, messageBody: url, messageType: "image", messageTime: getCurrentTime(), messageDate: getCurrentDateWithTime(), isIncoming: false)
                DataService.instance.addChatMessage(isComefromRandomORMyCHat: self?.isComefromRandomORMyCHat,chatID: self?.chatID ?? "", message: message,notReadBy: [rID],senderName: DataService.instance.currentUser.name, senderImage: DataService.instance.currentUser.image)
                let sender = PushNotificationSender()
                sender.sendPushNotification(senderToken: DataService.instance.currentUser.fcmToken, chatId:self?.chatID ?? "",isComefromRandomORMyCHat: self?.isComefromRandomORMyCHat ?? false, receiver: self?.passRecieverUser?.id ?? "", to: "\(self?.passRecieverUser!.fcmToken ?? "")", title: "\(DataService.instance.currentUser!.name)", body: "image",unread: 1)
            }
            else
            {
                print("Not upload picture")
            }
            
            self?.hideLoader()
        }
    }
    
    func uploadVideoInFirebase(selectedVideo: URL){
        ProgressHUD.show()
        DataService.instance.uploadVideos(videoURL: selectedVideo) { [weak self] (success, url) in
            if success {
                let message = Message(messageId: getUniqueId(), reciverId: rID, senderId: Auth.auth().currentUser!.uid, messageBody: url, messageType: "video", messageTime: getCurrentTime(), messageDate: getCurrentDateWithTime(), isIncoming: false)
                DataService.instance.addChatMessage(isComefromRandomORMyCHat: self?.isComefromRandomORMyCHat,chatID: self?.chatID ?? "", message: message,notReadBy: [rID],senderName: DataService.instance.currentUser.name,senderImage: DataService.instance.currentUser.image)
                let sender = PushNotificationSender()
                sender.sendPushNotification(senderToken: DataService.instance.currentUser.fcmToken,chatId:self?.chatID ?? "",isComefromRandomORMyCHat: self?.isComefromRandomORMyCHat ?? false, receiver: self?.passRecieverUser?.id ?? "", to: "\(self?.passRecieverUser!.fcmToken ?? "")", title: "\(DataService.instance.currentUser!.name)", body: "video",unread: 1)
                ProgressHUD.dismiss()
                print("Uploaded")
            }
            else
            {
                ProgressHUD.dismiss()
                print("Not upload Video")
            }
            
        }
    }
    
    func uploadGifsInFirebase(selectedGif: URL){
        ProgressHUD.show()
        DataService.instance.uploadGifs(selectedGif: selectedGif) { [weak self] (success, url) in
            if success {
                let message = Message(messageId: getUniqueId(), reciverId: rID, senderId: Auth.auth().currentUser!.uid, messageBody: url, messageType: "gif", messageTime: getCurrentTime(), messageDate: getCurrentDateWithTime(), isIncoming: false)
                DataService.instance.addChatMessage(isComefromRandomORMyCHat: self?.isComefromRandomORMyCHat,chatID: self?.chatID ?? "", message: message,notReadBy: [rID],senderName: DataService.instance.currentUser.name,senderImage: DataService.instance.currentUser.image)
                let sender = PushNotificationSender()
                sender.sendPushNotification(senderToken: DataService.instance.currentUser.fcmToken,chatId:self?.chatID ?? "",isComefromRandomORMyCHat: self?.isComefromRandomORMyCHat ?? false, receiver: self?.passRecieverUser?.id ?? "", to: "\(self?.passRecieverUser!.fcmToken ?? "")", title: "\(DataService.instance.currentUser!.name)", body: "video",unread: 1)
                ProgressHUD.dismiss()
                print("Uploaded")
            }
            else
            {
                ProgressHUD.dismiss()
                print("Not upload Video")
            }
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
            if mediaType  == "public.image" {
                guard let image = info[.originalImage] as? UIImage else {
                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                }
                if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                    if  isAnimatedImage(imageURL) == true {
                        print("gif Selected")
                        uploadGifsInFirebase(selectedGif: imageURL)
                    }
                    else
                    {
                        print("Image Selected")
                        uploadPictureInFirebase(selectedImage: image)
                    }
                }
            }
            
            if mediaType == "public.movie" {
                print("Video Selected")
                if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    uploadVideoInFirebase(selectedVideo: videoURL as URL)
                }
            }
        }
    }
    
    func zoomImage(at indexpath: Int){
        if messagesArray[indexpath].messageType == "image"{
            let images = [
                LightboxImage(imageURL: URL(string: messagesArray[indexpath].messageBody)!),
                
            ]
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dynamicBackground = true
            present(controller, animated: true, completion: nil)
        }
        else if messagesArray[indexpath].messageType == "video"{
            let selectedVideo = messagesArray[indexpath].messageBody
            player = AVPlayer(url: URL(string: selectedVideo)!)
            playerViewController.player = player
            self.present(playerViewController, animated: true, completion: nil)
            player.play()
        }
        
    }
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
        if isComeFromFirendsOrChatList == true {
            let othertUserID = chatID?.replacingOccurrences(of: DataService.instance.currentUser!.id, with: "")
            rID = othertUserID ?? ""
            print("Other userID is: \(othertUserID!)")
            DataService.instance.getUserOfID(userID: othertUserID!) {[weak self] (success, returnedUser) in
                if success{
                    self?.passRecieverUser = returnedUser
                    self?.imgView.sd_setImage(with: URL(string: returnedUser?.image ?? ""), placeholderImage: placeHolderImage, options: SDWebImageOptions.forceTransition)
                    
                }
            }
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of messages \(messagesArray.count)")
        return messagesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= messagesArray.count{
            return UITableViewCell()
        }
        if messagesArray[indexPath.row].messageType == "image"  || messagesArray[indexPath.row].messageType == "gif" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MediaCell
            if messagesArray[indexPath.row].isIncoming {
                cell.backGroundView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.stackView.alignment = .leading
                cell.lblTime.textAlignment = .left
                cell.btnPlay.isHidden = true
                cell.lblTime.text = messagesArray[indexPath.row].messageDate
                cell.imgView.tag = indexPath.row
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapped(sender:)))
                cell.imgView.addGestureRecognizer(tapGesture)
                cell.imgView.sd_setImage(with: URL(string: messagesArray[indexPath.row].messageBody), placeholderImage: UIImage(named: "placeHolder"), options: .forceTransition)
                return cell
            }
            else
            {
                cell.backGroundView?.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                cell.lblTime.text = messagesArray[indexPath.row].messageDate
                cell.lblTime.textAlignment = .right
                cell.stackView.alignment = .trailing
                cell.imgView.tag = indexPath.row
                cell.btnPlay.isHidden = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
                cell.imgView.addGestureRecognizer(tapGesture)
                cell.imgView.sd_setImage(with: URL(string: messagesArray[indexPath.row].messageBody), placeholderImage: UIImage(named: "placeHolder"), options: .forceTransition)
                return cell
            }
        }
        else if messagesArray[indexPath.row].messageType == "video" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MediaCell
            if messagesArray[indexPath.row].isIncoming {
                cell.backGroundView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.stackView.alignment = .leading
                cell.lblTime.textAlignment = .left
                cell.btnPlay.isHidden = false
                cell.lblTime.text = messagesArray[indexPath.row].messageDate
                cell.imgView.tag = indexPath.row
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapped(sender:)))
                cell.imgView.addGestureRecognizer(tapGesture)
                getThumbnailImageFromVideoUrl(url: URL(string: self.messagesArray[indexPath.row].messageBody)!) { (thumbImage) in
                    cell.imgView.image = thumbImage
                }
                return cell
            }
            else
            {
                cell.backGroundView?.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                cell.lblTime.text = messagesArray[indexPath.row].messageDate
                cell.lblTime.textAlignment = .right
                cell.stackView.alignment = .trailing
                cell.imgView.tag = indexPath.row
                cell.btnPlay.isHidden = false
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
                cell.imgView.addGestureRecognizer(tapGesture)
                getThumbnailImageFromVideoUrl(url: URL(string: self.messagesArray[indexPath.row].messageBody)!) { (thumbImage) in
                    cell.imgView.image = thumbImage
                }
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsTextCell", for: indexPath) as! ChatsTextCell
            cell.selectionStyle = .none
            if messagesArray.indices.contains(indexPath.row){
                cell.setData(message: messagesArray[indexPath.row])
                if messagesArray[indexPath.row].isIncoming == false {
                    cell.setBubble(type: .outgoing)
                }
                else
                {
                    cell.setBubble(type: .incoming)
                }
                return cell
            }else{
                return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            }
        }
    }
    
    
    @objc func handleTapped(sender:UITapGestureRecognizer){
        //        if messagesArray[sender.view?.tag ?? 0].messageType == "image"{
        zoomImage(at: sender.view?.tag ?? 0)
        //}
    }
    @IBAction func btnCameraTapped(_ sender: Any){
        self.showImagePicker()
    }
    
    @IBAction func sendBtnTapped(_ sender:Any){
        if messageTxtView.text != ""{
            let m = messageTxtView.text
            let message = Message(messageId: getUniqueId(), reciverId: rID, senderId: Auth.auth().currentUser!.uid, messageBody: messageTxtView.text, messageType: "text", messageTime: getCurrentTime(), messageDate: getCurrentDateWithTime(), isIncoming: false)
            DataService.instance.addChatMessage(isComefromRandomORMyCHat: isComefromRandomORMyCHat, chatID: chatID!, message: message,notReadBy: [rID],senderName: DataService.instance.currentUser.name,senderImage: DataService.instance.currentUser.image)
            self.messageTxtView.text = ""
            let sender = PushNotificationSender()
            sender.sendPushNotification(senderToken: DataService.instance.currentUser.fcmToken,chatId:chatID!,isComefromRandomORMyCHat: isComefromRandomORMyCHat, receiver: passRecieverUser?.id ?? "", to: "\(self.passRecieverUser!.fcmToken)", title: "\(DataService.instance.currentUser!.name)", body: m!,unread: 1)
            print(sender)
            //
            //                        DataService.instance.getUnreadCountOfUser(string: self.user.userID) { success, unread in
            //                            if success{
            //                                let sender = PushNotificationSender()
            //                                sender.sendPushNotification(to: "\(self.user.fcmToken)", title: "New Message from \(DataService.instance.currentUser!.name)", body: m!,unread: unread + 1)
            //                    let usersRef = Firestore.firestore().collection("users").document(self.user.userID)
            //                    usersRef.setData(["unread": unread + 1], merge: true)
            //                }
            //
            //            }
            
        }else{
            
        }
    }
    
}

extension MessagesVC:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let sizeToFitIn = CGSize(width: self.messageTxtView.bounds.size.width, height: 150)
        let newSize = self.messageTxtView.sizeThatFits(sizeToFitIn)
        self.txtMessageHeight.constant = newSize.height
    }
}
extension MessagesVC: LightboxControllerPageDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
}

func isAnimatedImage(_ imageUrl: URL) -> Bool {
    if let data = try? Data(contentsOf: imageUrl),
       let source = CGImageSourceCreateWithData(data as CFData, nil) {
        
        let count = CGImageSourceGetCount(source)
        return count > 1
    }
    return false
}
