//
//  HomeViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit
import ProgressHUD
import SDWebImage

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
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        dashboardViews.forEach { (view) in
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleDashobardView(sender:)))
            view.addGestureRecognizer(tapgesture)
            view.roundCorners(corners: [.topRight, .bottomLeft], radius: 18)
        }
        getTodayMood()
    }
    
    func getTodayMood(){
        ProgressHUD.show()
        DataService.instance.getMoodByDate { [weak self] (success, mood) in
            if success {
                ProgressHUD.dismiss()
                self?.appDelegate.isMoodFetched = true
                self?.appDelegate.mood = mood
                self?.lblMoodValue.text = "\(mood?.moodValue ?? 0)"
                self?.lblMoodValue.font = UIFont(name: "Poppins-Medium", size: 32)
                switch mood?.moodType {
                case "Angry":
                    self?.moodImage.image = #imageLiteral(resourceName: "emoji1")
                case "Sad":
                    self?.moodImage.image = #imageLiteral(resourceName: "emoji2")
                case "Happy":
                    self?.moodImage.image = #imageLiteral(resourceName: "emoji4")
                case "Blush":
                    self?.moodImage.image = #imageLiteral(resourceName: "emoji3")
                default:
                    self?.moodImage.image = #imageLiteral(resourceName: "emoji_think")
                }
            }
            else
            {
                self?.appDelegate.isMoodFetched = false
                self?.moodImage.image = UIImage(named: "icon_submit_mood")
                self?.lblMoodValue.font = UIFont(name: "Poppins-Medium", size: 18)
                self?.lblMoodValue.text = "Submit your mood"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = DataService.instance.currentUser
        profileImgView.sd_setImage(with: URL(string: user?.image ?? "" ), placeholderImage: placeHolderImage, options: .forceTransition)
        lblName.text = user?.name
        lblEmail.text = user?.email
    }
    
    //MARK:- Supporting Functions
    
    @objc func handleDashobardView(sender: UITapGestureRecognizer){
        switch sender.view?.tag {
        case 1:
            print("1")
        case 2:
            print("2")
        case 3:
            print("3")
        case 4:
            print("4")
        default:
            ProgressHUD.show()
            DataService.instance.getMoodByDate { (success, mood) in
                if success {
                    ProgressHUD.dismiss()
                    Alert.showMsg(title: "Oops", msg: "Today mood is already submitted.", btnActionTitle: "OK")
                }
                else
                {
                    ProgressHUD.dismiss()
                    let popUp = PopUpMood()
                    popUp.modalPresentationStyle = .overFullScreen
                    popUp.modalTransitionStyle = .crossDissolve
                    popUp.delegateRefresh = self
                    self.present(popUp, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    //MARK:- Actions
    
    
}

extension HomeViewController: refresh {
    func moodRefresh(success: Bool) {
        if true {
            getTodayMood()
        }
    }
    
    
}
