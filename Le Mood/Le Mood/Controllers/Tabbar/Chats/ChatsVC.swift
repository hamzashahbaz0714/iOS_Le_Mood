//
//  ChatsVC.swift
//  Wind Searched
//
//  Created by Hamza Shahbaz on 07/01/20.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import FirebaseAuth
import FirebaseFirestore

class ChatsVC: UIViewController {
    
    
    //MARK:- Propeties
    
    @IBOutlet weak var tableView:UITableView!
    var chats = [Chat]()
    var user = [UserModel]()
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChatList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if Auth.auth().currentUser?.uid != nil{
//            ProgressHUD.show("Loading chats")
//            let chatReference = Firestore.firestore().collection("chats")
//            chatReference.addSnapshotListener({ (snapShot, error) in
//                DataService.instance.getAllChats { (returnedArray) in
//                    ProgressHUD.dismiss()
//                    self.chats = returnedArray
//                    self.tableView.reloadData()
//                }
//            })
//        }else{
//            print("sdljcnvsa")
//        }
    }
    
    //MARK:- Supporting Functions
    
    func loadChatList(){
        
        tableView.delegate = self
        tableView.dataSource = self
        if Auth.auth().currentUser?.uid != nil{
            ProgressHUD.show("Loading chats")
            let chatReference = Firestore.firestore().collection("chats")
            chatReference.addSnapshotListener({ (snapShot, error) in
                DataService.instance.getAllChats { (returnedArray) in
                    ProgressHUD.dismiss()
                    self.chats = returnedArray
                    self.tableView.reloadData()
                }
            })
        }else{
            let popUp = UIAlertController(title: "Warning", message: "You must be logged in to view", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (okTapped) in
                self.tabBarController?.selectedIndex = 4
            }
            popUp.addAction(okAction)
            self.present(popUp,animated: true)
        }
    }
    
    
}
extension ChatsVC:UITableViewDataSource,UITableViewDelegate,ChatsCellDelegate{
    
    func openProfile(uid: UserModel) {
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
        cell.chat = chats[indexPath.row]
        cell.initCell()
        DataService.instance.getUserOfID(userID: chats[indexPath.row].otherUser) { (success, returnedUser) in
            if success{
                self.user.append(returnedUser!)
                cell.nameLbl.text = returnedUser!.name
                cell.profileImg.sd_setImage(with: URL(string: returnedUser!.image), placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
            }
        }
        if cell.chat.notReadBy.contains(DataService.instance.currentUser!.id){
            cell.dotImg.isHidden = false
        }else{
            cell.dotImg.isHidden = true
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
        vc.chatID = chats[indexPath.row].chatId
        rID = chats[indexPath.row].otherUser
        vc.notReadBy = self.chats[indexPath.row].notReadBy
        vc.passRecieverName = user[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
