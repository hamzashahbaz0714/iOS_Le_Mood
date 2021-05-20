//
//  SignupViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit

class SignupViewController: UIViewController {

    //MARK:- Properties
    
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    @IBAction func btnAlreadyHaveAnAccountTapped(_ sender: Any){
        self.popViewController()
    }
    
    @IBAction func btnSignupTapped(_ sender: Any){
        let controller: HomeViewController = HomeViewController.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)

    }

}
