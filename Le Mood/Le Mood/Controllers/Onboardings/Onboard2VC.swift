//
//  Onboard2VC.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit

class Onboard2VC: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var skipView: UIView!

    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        skipView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)

    }
    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    
    @IBAction func btnSkipTapped(_ sender: Any){
        let controller: LoginViewController = LoginViewController.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: Any){
        let controller: Onboard3VC = Onboard3VC.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
}
