//
//  RandomChatVC.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 23/06/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import ProgressHUD
class RandomChatVC: UIViewController {

    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var randomChatBtnView: UIView!
    var chats = [Chat]()
    
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
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        randomChatBtnView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
    }
    
    //MARK:- Supporting Functions
    
    func loadChatList(){
        
        tableView.delegate = self
        tableView.dataSource = self
        if Auth.auth().currentUser?.uid != nil{
            ProgressHUD.show("Loading chats")
            let chatReference = Firestore.firestore().collection("randomChats")
            chatReference.addSnapshotListener({ (snapShot, error) in
                DataService.instance.getRandomAllChats { (returnedArray) in
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
    
    @IBAction func btnRandomChatTapped(_ sender: Any){
        let controller: RandomChatSelectVC = RandomChatSelectVC.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
    
}
extension RandomChatVC:UITableViewDataSource,UITableViewDelegate,ChatsCellDelegate{
    
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
                cell.nameLbl.text = returnedUser!.nikName
                cell.profileImg.sd_setImage(with: URL(string: returnedUser!.image), placeholderImage: placeHolderImage)
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
        if let cell = tableView.cellForRow(at: indexPath) as? ChatsCell {
            let name = cell.nameLbl.text
            vc.passName = name
        }
        vc.chatID = chats[indexPath.row].chatId
        vc.notReadBy = self.chats[indexPath.row].notReadBy
        vc.isComeFromFirendsOrChatList = true
        vc.isComefromRandomORMyCHat = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
