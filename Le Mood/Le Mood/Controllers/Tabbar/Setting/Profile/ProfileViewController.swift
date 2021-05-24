//
//  ProfileViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 21/05/2021.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var genderImage: UIButton!
    @IBOutlet weak var profileImgView: UIImageView!
    
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserProfile()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)

    }
    
    //MARK:- Supporting Functions
    
    func setUserProfile(){
        let user = DataService.instance.currentUser
        lblName.text = user?.name
        lblEmail.text = user?.email
        lblCountry.text = user?.country
        lblRegion.text = user?.region
        lblGender.text = user?.gender
        profileImgView.sd_setImage(with: URL(string: user?.image ?? "" ), placeholderImage: placeHolderImage, options: .forceTransition)
        if user?.gender == "male" {
            genderImage.setImage(UIImage(named: "icon_male"), for: .normal)
        }
        else if user?.gender == "female" {
            genderImage.setImage(UIImage(named: "icon_female"), for: .normal)

        }
        else
        {
            genderImage.setImage(UIImage(named: "icon_other"), for: .normal)
        }
    }
    
    
    //MARK:- Actions
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
    
    @IBAction func btnEditProfile(_ sender: Any){
        let controller: EditProfileViewController = EditProfileViewController.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
}
