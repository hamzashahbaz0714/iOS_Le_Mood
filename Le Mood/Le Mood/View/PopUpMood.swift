//
//  ChangePasswordViewController.swift
//  Sculpt
//
//  Created by Bukhari Syed Saood on 11/24/20.
//

import UIKit
import Firebase
import ProgressHUD


protocol refresh : NSObject{
    func moodRefresh(success: Bool)
}

class PopUpMood: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet var moodImages: [UIImageView]!
    @IBOutlet weak var moodeSlider: UISlider!
    @IBOutlet weak var selectedMoodValue: UILabel!
    @IBOutlet weak var selectedMoodName: UILabel!
    @IBOutlet weak var selectMoodImg: UIImageView!
    
    weak var delegateRefresh : refresh?
    var currnetUser = DataService.instance.currentUser
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        selectedMoodValue.text = "100"
        selectedMoodName.text = "Excited"
        moodeSlider.value = 100
        moodImages.forEach { (img) in
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleMoodimages(sender:)))
            img.addGestureRecognizer(tapgesture)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        popUpView.roundCorners(corners: [.topRight, .bottomLeft], radius: 40)
    }
    
    
    //MARK:- Supporting Functions
    
    @objc func handleMoodimages(sender: UITapGestureRecognizer){
        switch sender.view?.tag {
        case 1:
            selectMoodImg.image = moodImages[0].image
            selectedMoodName.text = "Angry"
        case 2:
            selectMoodImg.image = moodImages[1].image
            selectedMoodName.text = "Sad"
        case 3:
            selectMoodImg.image = moodImages[2].image
            selectedMoodName.text = "Happy"
        case 4:
            selectMoodImg.image = moodImages[3].image
            selectedMoodName.text = "Blush"
        default:
            selectMoodImg.image = moodImages[4].image
            selectedMoodName.text = "Excited"
        }
        
    }
    
    //MARK:- Actions
    
    @IBAction func btnCrossTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didChangedSliderValue(_ sender: UISlider) {
        selectedMoodValue.text = "\(Int(moodeSlider.value))"
        
        if moodeSlider.value <= 100  && moodeSlider.value >= 80{
            selectMoodImg.image = UIImage(named: "5")
            selectedMoodName.text = "Excited"
        }
        else if moodeSlider.value <= 80  && moodeSlider.value >= 60 {
            selectMoodImg.image = UIImage(named: "4")
            selectedMoodName.text = "Blush"
        }
        else if moodeSlider.value <= 60  && moodeSlider.value >= 40 {
            selectMoodImg.image = UIImage(named: "3")
            selectedMoodName.text = "Happy"
        }
        else if moodeSlider.value <= 40  && moodeSlider.value >= 20  {
            selectMoodImg.image = UIImage(named: "2")
            selectedMoodName.text = "Sad"
        }
        else
        {
            selectMoodImg.image = UIImage(named: "1")
            selectedMoodName.text = "Angry"
        }
    }
    
    @IBAction func btnSubmitMoodTapped(_ sender: Any){
        let currnetUser = DataService.instance.currentUser
        Alert.showWithTwoActions(title: "Confirm", msg: "Are you sure want to submit your mood?", okBtnTitle: "Yes", okBtnAction: {
            ProgressHUD.show()
            let docId = getUniqueId()
            let mood = MoodModel(moodId: docId, moodType: self.selectedMoodName.text!, moodValue: Int(self.moodeSlider.value), time: getTime(), date: getCurrentDate(),country: currnetUser?.country ?? "", state: currnetUser?.region ?? "")
            DataService.instance.saveMood(mood: mood, docId: docId)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                DataService.instance.getUserOfID(userID: currnetUser?.id ?? "") { (success, user) in
                    if success {
                        DataService.instance.setCurrentUser(user: user!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.delegateRefresh?.moodRefresh(success: true)
                            ProgressHUD.dismiss()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        ProgressHUD.dismiss()
                    }
                }

            }
        }, cancelBtnTitle: "Cancel") {
            
        }
    }
}
