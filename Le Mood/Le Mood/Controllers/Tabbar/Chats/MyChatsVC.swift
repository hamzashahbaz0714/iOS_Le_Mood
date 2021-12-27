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

class MyChatsVC: UIViewController {
    
    
    //MARK: - Propeties
    
    @IBOutlet weak var tableView:UITableView!
    var chats = [Chat]()
    
    //MARK: - Controller Life Cycle
    
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
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    
    //MARK: - Supporting Functions
    
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
extension MyChatsVC:UITableViewDataSource,UITableViewDelegate,ChatsCellDelegate{
    
    func openProfile(uid: UserModel) {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
        cell.chat = chats[indexPath.row]
        DataService.instance.getUserOfID(userID: chats[indexPath.row].otherUser) { (success, returnedUser) in
            if success{
                cell.nameLbl.text = returnedUser!.name
                cell.profileImg.sd_setImage(with: URL(string: returnedUser!.image), placeholderImage: placeHolderImage)
                cell.returnedUser = returnedUser
                cell.setEmoji()
            }
        }
        cell.initCell()

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
        if let cell = tableView.cellForRow(at: indexPath) as? ChatsCell {
            let name = cell.nameLbl.text
            vc.passName = name
        }
        vc.chatID = chats[indexPath.row].chatId
        vc.notReadBy = self.chats[indexPath.row].notReadBy
        vc.isComeFromFirendsOrChatList = true
        vc.isComefromRandomORMyCHat = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
