//
//  InboxViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 27/05/2021.
//

import UIKit

class InboxViewController: UIViewController {

    //MARK:- Properties
    
    var passFriend: UserModel?
    @IBOutlet weak var lblFriend: UILabel!
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblFriend.text = passFriend?.name

    }
    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
}
