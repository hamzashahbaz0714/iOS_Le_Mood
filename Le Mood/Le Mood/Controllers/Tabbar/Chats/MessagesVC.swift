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
import FirebaseFirestore

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of messages \(messagesArray.count)")
        return messagesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var detailLbl:UILabel!
    @IBOutlet weak var priceLbl:UILabel!
    @IBOutlet weak var viewDetailsBtn:UIButton!
    
//    var booking:Booking!
    
    var chatID:String?
    var notReadBy = [String]()
    
    var isEdited = false
    var messagesArray = [Message]()
    
    @IBOutlet weak var messageTxtView:UITextView!
    
        fileprivate let cellId = "id123"
        

//    var messagesFromServer = [ChatMessage]()
//
//        fileprivate func attemptToAssembleGroupedMessages() {
//            print("Attempt to group our messages together based on Date property")
//
//            let groupedMessages = Dictionary(grouping: messagesFromServer) { (element) -> Date in
//                return element.date.reduceToMonthDayYear()
//            }
//
//            // provide a sorting for your keys somehow
//            let sortedKeys = groupedMessages.keys.sorted()
//            sortedKeys.forEach { (key) in
//                let values = groupedMessages[key]
//                chatMessages.append(values ?? [])
//            }
//
//        }
//
//        var chatMessages = [[ChatMessage]]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
            
        //view.bindKeyboard()
        let tapGester = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGester)
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9764705882, blue: 1, alpha: 1)
            
//
//        let othertUserID = chatID?.replacingOccurrences(of: DataService.instance.currentUser!.id, with: "")
//        let bookingReference = Firestore.firestore().collection("bookings")
//        bookingReference.addSnapshotListener { (snapShot, error) in
//            DataService.instance.getAllUsersBookingForMessages(userID: Auth.auth().currentUser!.uid,otherUserID:othertUserID!) { (returnedArray) in
//                if returnedArray.count > 0{
//                    self.booking = returnedArray.first!
//                    self.viewDetailsBtn.isHidden = false
//                    self.initCell()
//                }else{
//                    self.detailLbl.text = "No booking found"
//                    self.priceLbl.text = ""
//                    self.viewDetailsBtn.isHidden = true
//
//                }
//
//            }
//        }
        DataService.instance.getChatOfID(chatID: self.chatID!) { (success, returnedChat) in
            if success{
                if returnedChat!.notReadBy.contains(Auth.auth().currentUser!.uid){
                    if let index = returnedChat!.notReadBy.firstIndex(of: Auth.auth().currentUser!.uid){
                        returnedChat!.notReadBy.remove(at: index)
                        DataService.instance.updateChatNotRead(chatID: self.chatID!, notReadBy: returnedChat!.notReadBy)
                    }
                }
            }
        }
        
        
       DispatchQueue.main.async {
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
                   //self.attemptToAssembleGroupedMessages()
               }
           })
       }
        
            //attemptToAssembleGroupedMessages()
            
    }
    
//    func initCell(){
//        DataService.instance.getUserOfID(userID: booking.bookedBy) { (success, returnedUser) in
//            if success{
//                self.detailLbl.text = "\(self.booking.bookingTime) - \(returnedUser!.name)"
//                self.priceLbl.text = "$\(self.booking.totalFee)"
//            }
//        }
//    }
    
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
    
    @IBAction func viewDetailsBtnTapped(_ sender:Any){
//        if self.booking.status == "Completed" || (checkTimeStamp(date: booking.bookingDate)) == false{
//            let vc = storyboard?.instantiateViewController(withIdentifier: "ReservationRequestDetailsVC") as! ReservationRequestDetailsVC
//            vc.booking =  self.booking
//            vc.isUser = true
//            self.present(vc, animated: true, completion: nil)
//        }else{
//            let vc = storyboard?.instantiateViewController(withIdentifier: "ReservationRequestDetailsVC") as! ReservationRequestDetailsVC
//            vc.booking = self.booking
//            vc.isUser = true
//            self.present(vc, animated: true, completion: nil)
//        }
        
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let othertUserID = chatID?.replacingOccurrences(of: DataService.instance.currentUser!.id, with: "")
        print("Other userID is: \(othertUserID!)")
        DataService.instance.getUserOfID(userID: othertUserID!) { (success, returnedUser) in
            if success{
                print("Other user is: \(returnedUser!.name)")
                self.navigationItem.title = returnedUser!.name
            }
        }
        
    }
 
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
        
//    class DateHeaderLabel: UILabel {
//
//            override init(frame: CGRect) {
//                super.init(frame: frame)
//
//                backgroundColor = .clear
//                textColor = .black
//                textAlignment = .center
//                translatesAutoresizingMaskIntoConstraints = false // enables auto layout
//                font = UIFont.boldSystemFont(ofSize: 14)
//            }
//
//            required init?(coder aDecoder: NSCoder) {
//                fatalError("init(coder:) has not been implemented")
//            }
//
//            override var intrinsicContentSize: CGSize {
//                let originalContentSize = super.intrinsicContentSize
//                let height = originalContentSize.height + 12
//                layer.cornerRadius = height / 2
//                layer.masksToBounds = true
//                return CGSize(width: originalContentSize.width + 20, height: height)
//            }
//
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let firstMessageInSection = messagesArray.first {
//                let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MM/dd/yyyy"
//               let dateString = dateFormatter.string(from: Date.dateFromCustomString(customString: firstMessageInSection.messageDate))
//
//                let label = DateHeaderLabel()
//                label.text = dateString
//
//                let containerView = UIView()
//
//                containerView.addSubview(label)
//                label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//                label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//
//                return containerView
//
//        }
//        return nil
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        if messagesArray.indices.contains(indexPath.row){
            
            cell.chatMessage = messagesArray[indexPath.row]
            return cell
        }else{
            return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }
    
    @IBAction func sendBtnTapped(_ sender:Any){
        if messageTxtView.text != "" && isEdited == true{
            let message = Message(messageId: getUniqueId(), reciverId: rID, senderId: Auth.auth().currentUser!.uid, messageBody: messageTxtView.text, messageType: "Text", messageTime: getCurrentTime(), messageDate: getCurrentDateWithTime(), isIncoming: false)
            DataService.instance.addChatMessage(chatID: chatID!, message: message,notReadBy: [String]())
            self.messageTxtView.textColor = .lightGray
            self.messageTxtView.text = "Type Something..."
            isEdited = false
            self.messageTxtView.resignFirstResponder()
            
        }else{
            
        }
    }


}

extension MessagesVC:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == messageTxtView && isEdited == false{
            textView.text = ""
            textView.textColor = .black
            isEdited = true
        }
    }
}
