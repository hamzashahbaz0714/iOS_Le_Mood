//
//  StatisticsViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 25/05/2021.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    //MARK:- Propeties
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet var statisticsViews: [UIView]!
    @IBOutlet weak var lblMoodValue: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    //MARK:- Controller Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTodayMood()
        let user = DataService.instance.currentUser
        profileImgView.sd_setImage(with: URL(string: user?.image ?? "" ), placeholderImage: placeHolderImage, options: .forceTransition)
        lblName.text = user?.name
        lblEmail.text = user?.email
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        statisticsViews.forEach { (view) in
            view.roundCorners(corners: [.topRight, .bottomLeft], radius: 18)
        }
    }
    
    //MARK:- Supporting Functions
    
    
    
    func getTodayMood(){
        if appDelegate.isMoodFetched == true {
            let user = DataService.instance.currentUser
            if user?.lastMoodDate != "" && user?.lastMoodDate == getCurrentDate() && user?.lastMoodDate != "Not found"{
                self.appDelegate.isMoodFetched = true
                self.lblMoodValue.text = "\(user?.moodValue ?? 0)"
                self.lblMoodValue.font = UIFont(name: "Poppins-Medium", size: 32)
                switch user?.moodType {
                case "Angry":
                    self.moodImage.image = #imageLiteral(resourceName: "emoji1")
                case "Sad":
                    self.moodImage.image = #imageLiteral(resourceName: "emoji2")
                case "Happy":
                    self.moodImage.image = #imageLiteral(resourceName: "emoji4")
                case "Blush":
                    self.moodImage.image = #imageLiteral(resourceName: "emoji3")
                default:
                    self.moodImage.image = #imageLiteral(resourceName: "emoji_think")
                }
            }
        }
        else{
            self.moodImage.image = UIImage(named: "icon_submit_mood")
            self.lblMoodValue.font = UIFont(name: "Poppins-Medium", size: 18)
            self.lblMoodValue.text = "Submit your mood"
        }
    }
    
    
    
    //MARK:- Actions
    
    
}
