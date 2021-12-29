//
//  LanguagesViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 02/06/2021.
//


protocol dataPass : NSObject{
    func languages(select:Bool)
}

import UIKit
import Firebase
import ProgressHUD
class LanguagesViewController: UIViewController {
    
    //MARK:- Propeties
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSelectLanguage: UIView!

    var iscomeFromSelectLanugae = false
    
    weak var delegateLanguage : dataPass?
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if iscomeFromSelectLanugae == false {
            btnSelectLanguage.isHidden = true
        }
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        btnSelectLanguage.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        
    }
    
    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
    
    @IBAction func btnSelectTapped(_ sender: Any){
        self.delegateLanguage?.languages(select: true)
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
        if iscomeFromSelectLanugae == true {
            cell.btnSelect.isHidden = false
            if appdelegate.selectLanguage.contains(languageArr[indexPath.row]["name"] ?? "") {
                cell.btnSelect.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                cell.btnSelect.isSelected = true
            }
            else
            {
                cell.btnSelect.setImage(UIImage(systemName: "circle"), for: .normal)
                cell.btnSelect.isSelected = false
            }
        }
        else
        {
            cell.btnSelect.isHidden = true
        }
        cell.lblName.text = languageArr[indexPath.row]["name"]
        cell.lblNativeName.text = languageArr[indexPath.row]["nativeName"]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if iscomeFromSelectLanugae == true{
            if let cell = tableView.cellForRow(at: indexPath) as? LanguageCell {
                if cell.btnSelect.isSelected == false {
                    cell.btnSelect.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                        appdelegate.selectLanguage.append(languageArr[indexPath.row]["name"] ?? "")
                    print(appdelegate.selectLanguage)
                    cell.btnSelect.isSelected = true
                    self.tableView.reloadData()
                }
                else
                {
                    appdelegate.selectLanguage = appdelegate.selectLanguage.filter { $0 != languageArr[indexPath.row]["name"] }
                    print(appdelegate.selectLanguage)
                    cell.btnSelect.isSelected = false
                    self.tableView.reloadData()
                }
            }
        }
        else
        {
            let user = DataService.instance.currentUser
            let updateUser = UserModel(id: user?.id ?? "", name: user?.name ?? "", nikName: user?.nikName ?? "", email: user?.email ?? "", phoneNumber: user?.phoneNumber ?? "", image: user?.image ?? "", gender: user?.gender ?? "", deviceType: user?.deviceType ?? "", country: user?.country ?? "", region: user?.region ?? "",moodId: user?.moodId ?? "",moodType: user?.moodType ?? "",moodValue: user?.moodValue ?? 0,lastMoodDate: "",fcmToken: "", language: languageArr[indexPath.row]["name"] ?? "", isMoodVisible: user?.isMoodVisible ?? true)
            DataService.instance.updateUser(user: updateUser)
            DataService.instance.setCurrentUser(user: updateUser)
            Alert.showMsg(msg: "Your Language Updated")

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

