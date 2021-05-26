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

class AllFriendsViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var allFriendsArr = [UserModel]()
    
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
                self?.allFriendsArr = friends!
                self?.tableView.reloadData()
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
        return allFriendsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let data = allFriendsArr[indexPath.row]
        cell.lblContactName.text = data.name
        cell.lblContactNo.text = data.country
        cell.userImgView.sd_setImage(with: URL(string: data.image ), placeholderImage: placeHolderImage, options: .forceTransition)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
