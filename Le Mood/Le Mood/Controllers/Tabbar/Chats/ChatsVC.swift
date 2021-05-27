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

    @IBOutlet weak var tableView:UITableView!
    
    var chats = [Chat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            print("sdljcnvsa")
        }
    }
    

}
extension ChatsVC:UITableViewDataSource,UITableViewDelegate,ChatsCellDelegate{
    
    func openProfile(uid: UserModel) {
        print("")
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MainProfileVC") as! MainProfileVC
//        vc.user = uid
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
        cell.chat = chats[indexPath.row]
        cell.initCell()
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
        vc.chatID = chats[indexPath.row].chatId
        rID = chats[indexPath.row].otherUser
        vc.notReadBy = self.chats[indexPath.row].notReadBy
        self.navigationController?.pushViewController(vc, animated: true)
        //performSegue(withIdentifier: "InboxMessagesVC", sender: chats[indexPath.row].chatId)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let codeVC = segue.destination as? MessagesVC{
//            let barBtn = UIBarButtonItem()
//            barBtn.title = "Back"
//            navigationItem.backBarButtonItem = barBtn
//            codeVC.chatID = sender as? String
//        }
//    }
    
    
}
