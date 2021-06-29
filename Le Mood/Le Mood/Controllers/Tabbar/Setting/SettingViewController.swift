//
//  SettingViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 21/05/2021.
//

import UIKit
import Firebase
import ProgressHUD

class SettingViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var settingsView: [UIView]!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView.forEach { (views) in
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleSettingViews(sender:)))
            views.addGestureRecognizer(tapgesture)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = DataService.instance.currentUser
        profileImgView.sd_setImage(with: URL(string: user?.image ?? "" ), placeholderImage: placeHolderImage, options: .forceTransition)
        lblName.text = user?.name
        lblEmail.text = user?.email
        
    }
    
    //MARK:- Supporting Functions
    
    @objc func handleSettingViews(sender: UITapGestureRecognizer){
        switch sender.view?.tag {
        case 1:
            let controller: ProfileViewController = ProfileViewController.initiateFrom(Storybaord: .Main)
            self.pushController(contorller: controller, animated: true)
        case 2:
            print("Privacy Policy")
        case 3:
            print("")
            let controller: LanguagesViewController = LanguagesViewController.initiateFrom(Storybaord: .Main)
            self.pushController(contorller: controller, animated: true)
        case 4:
            print("random Chat")
            let controller: RandomChatSelectVC = RandomChatSelectVC.initiateFrom(Storybaord: .Main)
            self.pushController(contorller: controller, animated: true)
        default:
            print("Logout")
            Alert.showWithTwoActions(title: "Confirm", msg: "Are you sure want to Logout?", okBtnTitle: "Yes", okBtnAction: {
                ProgressHUD.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    ProgressHUD.dismiss()
                    do {
                        try Auth.auth().signOut()
                        self.navigationController?.popToRootViewController(animated: true)
                    } catch (let error) {
                        print((error as NSError).code)
                    }
                }
            }, cancelBtnTitle: "Cancel") {
                
            }
        }
        
    }
    
    
    //MARK:- Actions
    
    
    
}
