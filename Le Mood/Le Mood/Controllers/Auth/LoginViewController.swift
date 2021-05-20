//
//  LoginViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK:- Properties
    
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    @IBAction func btnDontHaveAnAccountTapped(_ sender: Any){
        let controller: SignupViewController = SignupViewController.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
    
    @IBAction func btnSignInTapped(_ sender: Any){
        let controller: TabbarViewController = TabbarViewController.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
}
