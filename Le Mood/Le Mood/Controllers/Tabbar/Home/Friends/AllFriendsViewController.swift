//
//  AllFriendsViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 26/05/2021.
//

import UIKit
import Contacts
import ProgressHUD
import SDWebImage
import Firebase
class AllFriendsViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var allFriendsArr = [UserModel]()
    var shuffleFriend = [UserModel]()
    var isComeFromLanguage: Bool?
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewLayout()
        getAllFriends()
        
    }
    
    
    //MARK:- Supporting Functions
    
    func setTableViewLayout() {
        ConfigureCell(tableView: tableView, collectionView: nil, nibName: "ContactCell", reuseIdentifier: "ContactCell", cellType: .tblView)
    }
    
    func getAllFriends(){
        ProgressHUD.show()
        DataService.instance.getAllFriends { [weak self] (success, friends) in
            if success {
                ProgressHUD.dismiss()
                if self?.isComeFromLanguage == true{
                    self?.allFriendsArr = friends!
                    self?.allFriendsArr.shuffle()
                    if self?.allFriendsArr.count  ?? 0 > 0{
                        self?.shuffleFriend.append((self?.allFriendsArr[0])!)
                    }
                    self?.tableView.reloadData()
                }
                else
                {
                    self?.allFriendsArr = friends!
                    self?.tableView.reloadData()
                }
             
            }
            else
            {
                ProgressHUD.dismiss()
                print("Not fetch the friends")
            }
        }
    }
    
    
    //MARK:- Actions
    
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
}

//MARK:- UITableViewDataSource UITableViewDelegate

extension AllFriendsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComeFromLanguage == true{
            return shuffleFriend.count
        }
        else
        {
            return allFriendsArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        if isComeFromLanguage == true {
            let data = shuffleFriend[indexPath.row]
            if data.moodType == "Angry" {
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji1")
            }
            else if data.moodType == "Sad"
            {
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji2")
            }
            else if data.moodType == "Happy" {
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji3")
            }
            else if data.moodType == "Blush" {
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji4")
            }
            else if data.moodType == "Excited"{
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji_think")
            }
            else
            {
                
                cell.moodValue.text = "--"
            }
            cell.lblContactName.text = data.name
            cell.lblContactNo.text = data.country
            cell.userImgView.sd_setImage(with: URL(string: data.image ), placeholderImage: placeHolderImage, options: .forceTransition)
        }
        else
        {
            let data = allFriendsArr[indexPath.row]
            if data.moodType == "Angry" {
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji1")
            }
            else if data.moodType == "Sad"
            {
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji2")
            }
            else if data.moodType == "Happy" {
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji3")
            }
            else if data.moodType == "Blush" {
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji4")
            }
            else if data.moodType == "Excited"{
                cell.moodValue.text = "\(data.moodValue)"
                cell.moodImageView.image = UIImage(named: "emoji_think")
            }
            else
            {
                
                cell.moodValue.text = "--"
            }
            cell.lblContactName.text = data.name
            cell.lblContactNo.text = data.country
            cell.userImgView.sd_setImage(with: URL(string: data.image ), placeholderImage: placeHolderImage, options: .forceTransition)
        }
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = allFriendsArr[indexPath.row]
        let controller: MessagesVC = MessagesVC.initiateFrom(Storybaord: .Main)
        let uid1 = Auth.auth().currentUser!.uid
        let uid2 = data.id
        if(uid1 > uid2){
            controller.chatID = uid1+uid2;
        }
        else{
            controller.chatID = uid2+uid1
        }
        rID = data.id
        controller.passRecieverUser = data
        self.pushController(contorller: controller, animated: true)
    }
    
    
}
