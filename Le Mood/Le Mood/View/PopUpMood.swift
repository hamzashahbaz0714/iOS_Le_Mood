//
//  ChangePasswordViewController.swift
//  Sculpt
//
//  Created by Bukhari Syed Saood on 11/24/20.
//

import UIKit

class PopUpMood: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet var moodImages: [UIImageView]!
    @IBOutlet weak var progrssBar: UIProgressView!
    @IBOutlet weak var progrssLabel: UILabel!
    @IBOutlet weak var selectMoodImg: UIImageView!
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        progrssLabel.text = "100"
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
            progrssBar.progress = 0
            progrssLabel.text = "0"
            selectMoodImg.image = moodImages[0].image
        case 2:
            progrssBar.progress = 0.4
            progrssLabel.text = "40"
            selectMoodImg.image = moodImages[1].image
        case 3:
            progrssBar.progress = 0.6
            progrssLabel.text = "60"
            selectMoodImg.image = moodImages[2].image
        case 4:
            progrssBar.progress = 0.8
            progrssLabel.text = "80"
            selectMoodImg.image = moodImages[3].image
        default:
            progrssBar.progress = 1
            progrssLabel.text = "100"
            selectMoodImg.image = moodImages[4].image
        }

    }
    
    //MARK:- Actions
    
    @IBAction func btnCrossTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }

}
