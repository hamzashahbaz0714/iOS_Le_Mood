//
//  ChatListViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 21/05/2021.
//

import UIKit

class ChatListViewController: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        ConfigureCell(tableView: tableView, collectionView: nil, nibName: "ChatListCell", reuseIdentifier: "ChatListCell", cellType: .tblView)

    }
    
    //MARK:- Supporting Functions
    
    
    
    //MARK:- Actions
    
    
}


extension ChatListViewController : UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 6
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        }
}
