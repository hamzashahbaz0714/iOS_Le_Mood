//
//  Onboard3VC.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit

class Onboard3VC: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var getStartedView: UIView!
    
    //MARK:- COntroller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStartedView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
    }
    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    
    @IBAction func btnGetStartedTapped(_ sender: Any){
        let controller: LoginViewController = LoginViewController.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
}
