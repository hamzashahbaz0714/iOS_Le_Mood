//
//  LanguagesViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 02/06/2021.
//

import UIKit
import Firebase
import ProgressHUD
class LanguagesViewController: UIViewController {
    
    //MARK:- Propeties
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var isComeFromPreffered = false
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        
    }
    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
    
}


extension LanguagesViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        cell.lblName.text = languageArr[indexPath.row]["name"]
        cell.lblNativeName.text = languageArr[indexPath.row]["nativeName"]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProgressHUD.show()
            DataService.instance.searchLanguageBaseFriend(language: languageArr[indexPath.row]["name"] ?? "") { (success, friends) in
                if success {
                    ProgressHUD.dismiss()
                    var newArr = friends
                    newArr?.shuffle()
                    if newArr?.count ?? 0 > 0 {
                        let user = DataService.instance.currentUser
                        let updateUser = UserModel(id: user?.id ?? "", name: user?.name ?? "", email: user?.email ?? "", phoneNumber: user?.phoneNumber ?? "", image: user?.image ?? "", gender: user?.gender ?? "", country: user?.country ?? "", region: user?.region ?? "",moodId: user?.moodId ?? "",moodType: user?.moodType ?? "",moodValue: user?.moodValue ?? 0,lastMoodDate: "",fcmToken: "", language: languageArr[indexPath.row]["name"] ?? "")
                        DataService.instance.updateUser(user: updateUser)
                        DataService.instance.setCurrentUser(user: updateUser)
                        ProgressHUD.dismiss()
                        let controller: MessagesVC = MessagesVC.initiateFrom(Storybaord: .Main)
                        let uid1 = Auth.auth().currentUser!.uid
                        let uid2 = newArr?[0].id
                        if(uid1 > uid2 ?? ""){
                            controller.chatID = (uid1+(uid2 ?? ""))
                        }
                        else{
                            controller.chatID = ((uid2 ?? "")+uid1)
                        }
                        rID = newArr?[0].id ?? ""
                        controller.passRecieverUser = newArr?[0]
                        self.pushController(contorller: controller, animated: true)
                    }
                    else
                    {
                        Alert.showWithTwoActions(title: "Oops", msg: "No user found against \(languageArr[indexPath.row]["name"] ?? "") language. Would you like to change language?", okBtnTitle: "Yes", okBtnAction: {
                        }, cancelBtnTitle: "No") {
                            self.popViewController()
                        }
                    }
                }
                else
                {
                    ProgressHUD.dismiss()
                    Alert.showMsg(msg: "Something went wrong. Please try again")
                }
            }
    }
    
}

//else
//{
//    DataService.instance.getAllFriends { (success, friends) in
//        if success {
//            ProgressHUD.dismiss()
//            var newArr = friends
//            newArr?.shuffle()
//            if newArr?.count ?? 0 > 0 {
//                let user = DataService.instance.currentUser
//                let updateUser = UserModel(id: user?.id ?? "", name: user?.name ?? "", email: user?.email ?? "", phoneNumber: user?.phoneNumber ?? "", image: user?.image ?? "", gender: user?.gender ?? "", country: user?.country ?? "", region: user?.region ?? "",moodId: user?.moodId ?? "",moodType: user?.moodType ?? "",moodValue: user?.moodValue ?? 0,lastMoodDate: "",fcmToken: "", language: languageArr[indexPath.row]["name"] ?? "")
//                DataService.instance.updateUser(user: updateUser)
//                DataService.instance.setCurrentUser(user: updateUser)
//                ProgressHUD.dismiss()
//                let controller: MessagesVC = MessagesVC.initiateFrom(Storybaord: .Main)
//                let uid1 = Auth.auth().currentUser!.uid
//                let uid2 = newArr?[0].id
//                if(uid1 > uid2 ?? ""){
//                    controller.chatID = (uid1+(uid2 ?? ""))
//                }
//                else{
//                    controller.chatID = ((uid2 ?? "")+uid1)
//                }
//                rID = newArr?[0].id ?? ""
//                controller.passRecieverUser = newArr?[0]
//                self.pushController(contorller: controller, animated: true)
//            }
//            else
//            {
//                Alert.showWithTwoActions(title: "Oops", msg: "No user found against \(languageArr[indexPath.row]["name"] ?? "") language. Would you like to change language?", okBtnTitle: "Yes", okBtnAction: {
//                }, cancelBtnTitle: "No") {
//                    self.popViewController()
//                }
//            }
//        }
//        else
//        {
//            ProgressHUD.dismiss()
//            Alert.showMsg(msg: "Something went wrong. Please try again")
//        }
//    }
//}
