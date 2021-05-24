//
//  Onboard1VC.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit

class Onboard1VC: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var skipView: UIView!
    
    //MARK:- Controller Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnRoundbackground(view: nextView)
        nextView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        skipView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)

    }
    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    @IBAction func btnSkipTapped(_ sender: Any){
        UserDefaults.standard.setValue(true, forKey: "WatchWalkThrough")
        let controller: LoginViewController = LoginViewController.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: Any){
        let controller: Onboard2VC = Onboard2VC.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
    
}
