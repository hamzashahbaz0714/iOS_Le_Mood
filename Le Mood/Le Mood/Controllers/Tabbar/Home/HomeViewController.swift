//
//  HomeViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit
import ProgressHUD
import SDWebImage
import FirebaseAuth

class HomeViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var dashboardViews: [UIView]!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMoodValue: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
        pushManager.registerForPushNotifications()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        dashboardViews.forEach { (view) in
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleDashobardView(sender:)))
            view.addGestureRecognizer(tapgesture)
//            view.roundCorners(corners: [.topRight, .bottomLeft], radius: 18)
        }
        print(UIDevice.current.name)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = DataService.instance.currentUser
        profileImgView.sd_setImage(with: URL(string: user?.image ?? "" ), placeholderImage: placeHolderImage, options: .forceTransition)
        lblName.text = user?.name
        lblEmail.text = user?.email
        getMood()

    }
    
    //MARK:- Supporting Functions
    
    
    func getMood(){
        
        let user = DataService.instance.currentUser
        if user?.lastMoodDate != "" && user?.lastMoodDate == getCurrentDate(){
            self.appDelegate.isMoodFetched = true
            self.lblMoodValue.text = "\(user?.moodValue ?? 0)"
            self.lblMoodValue.font = UIFont(name: "Poppins-Medium", size: 32)
            switch user?.moodType {
            case "Angry":
                self.moodImage.image = UIImage(named: "Emoji_1")
            case "Sad":
                self.moodImage.image = UIImage(named: "Emoji_2")
            case "Happy":
                self.moodImage.image = UIImage(named: "Emoji_3")
            case "Blush":
                self.moodImage.image = UIImage(named: "Emoji_4")
            default:
                self.moodImage.image = UIImage(named: "Emoji_5")
            }
        }
        else
        {
            self.appDelegate.isMoodFetched = false
            self.moodImage.image = UIImage(named: "icon_submit_mood")
            self.lblMoodValue.font = UIFont(name: "Poppins-Medium", size: 18)
            self.lblMoodValue.text = "Submit your mood"
        }
    }
    
    @objc func handleDashobardView(sender: UITapGestureRecognizer){
        switch sender.view?.tag {
        case 1:
            print("1")
            self.tabBarController?.selectedIndex = 2
        case 2:
            let controller: FriendsViewController = FriendsViewController.initiateFrom(Storybaord: .Main)
            self.pushController(contorller: controller, animated: true)
        case 3:
            print("3")
            self.tabBarController?.selectedIndex = 1
        case 4:
            print("4")
        default:
            let user = DataService.instance.currentUser
            if user?.lastMoodDate != "" && user?.lastMoodDate == getCurrentDate() && user?.lastMoodDate != "Not found"{
                Alert.showWithTwoActions(title: "Your Mood is already submitted", msg: "Would you like to update your mood?", okBtnTitle: "Yes", okBtnAction: {
                    let popUp = PopUpMood()
                    popUp.modalPresentationStyle = .overFullScreen
                    popUp.modalTransitionStyle = .crossDissolve
                    popUp.isEditOrUpdate = true
                    popUp.delegateRefresh = self
                    self.present(popUp, animated: true, completion: nil)
                }, cancelBtnTitle: "Cancel") {
                    
                }
            }
            else
            {
                let popUp = PopUpMood()
                popUp.modalPresentationStyle = .overFullScreen
                popUp.modalTransitionStyle = .crossDissolve
                popUp.delegateRefresh = self
                self.present(popUp, animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK:- Actions
    
    
}

extension HomeViewController: refresh {
    func moodRefresh(success: Bool) {
        if true {
            getMood()
        }
    }
    
    
}
