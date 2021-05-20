//
//  HomeViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var mainView: UIView!
    
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)

        
    }
    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    
}
