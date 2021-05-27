//
//  MoodFriendsViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 26/05/2021.
//

import UIKit
import Contacts
import ProgressHUD
import Firebase
import PhoneNumberKit
class MoodFriendsViewController: UIViewController {
    
    //MARK:- Properties
    
    var contactArr = [ContactsModel]()
    var moodFriends = [UserModel]()
    var user:UserModel!
    @IBOutlet weak var tableView: UITableView!
    
    let phoneNumberKit = PhoneNumberKit()
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewLayout()
        fetchContact()
    }
    
    //MARK:- Supporting Functions
    
    func setTableViewLayout() {
        ConfigureCell(tableView: tableView, collectionView: nil, nibName: "ContactCell", reuseIdentifier: "ContactCell", cellType: .tblView)
    }
    
    func fetchContact() {
        ProgressHUD.show()
        let store  = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self](granted, error) in
            if let error = error {
                print("Failed to request access!",error)
                return
            }
            if granted {
                
                print("granted access!")
                let keys = [CNContactGivenNameKey,CNContactPhoneNumbersKey, CNContactFamilyNameKey,CNContactNameSuffixKey,CNContactNamePrefixKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request) { (contact, stopPointerIfYpuWantStopEnumerating) in
                        
                        let contact = ContactsModel(name: "\(contact.givenName + " " + contact.familyName)", phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "")
                        self?.contactArr.append(contact)
                    }
                    DispatchQueue.main.async {
                        self?.getAllFriends()
//                        ProgressHUD.dismiss()
                    }
                    
                    
                }
                catch let err{
                    ProgressHUD.dismiss()
                    print("failed to enumerate contacts:", err)
                }
            }
            else
            {
                ProgressHUD.dismiss()
                print("access denied..")
            }
        }
    }
    
    func getAllFriends(){
        DataService.instance.getAllFriends { [weak self] (success, friends) in
            if success {
                for i in 0..<(self?.contactArr.count ?? 0){
                    for j in 0..<(friends?.count ?? 0) {

                        let mobileContact = self?.contactArr[i].phoneNumber
                        let phoneNumbers =  try? self?.phoneNumberKit.parse(mobileContact ?? "")
                        let firebaseContact = friends?[j].phoneNumber
                        let phoneNumbers1 =  try? self?.phoneNumberKit.parse(firebaseContact ?? "")
                        if phoneNumbers?.nationalNumber == phoneNumbers1?.nationalNumber {
                            self?.moodFriends.append((friends?[j])!)
                            break
                        }
                        
                    }
                }
                self?.tableView.reloadData()
                ProgressHUD.dismiss()
            }
            else
            {
                ProgressHUD.dismiss()
                print("Not fetch the friends")
            }
        }
    }
    
    //MARK:- Actions
    
    
}

//MARK:- UITableViewDataSource UITableViewDelegate

extension MoodFriendsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodFriends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let data = moodFriends[indexPath.row]
        cell.lblContactName.text = data.name
        cell.lblContactNo.text = data.phoneNumber
        cell.MessageView.isHidden = true
        cell.userImgView.sd_setImage(with: URL(string: data.image), placeholderImage: placeHolderImage, options: .forceTransition)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = moodFriends[indexPath.row]
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
        self.pushController(contorller: controller, animated: true)
    }
    
    
}
