//
//  HomeViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var dashboardViews: [UIView]!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        dashboardViews.forEach { (view) in
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleDashobardView(sender:)))
            view.addGestureRecognizer(tapgesture)
            view.roundCorners(corners: [.topRight, .bottomLeft], radius: 18)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = DataService.instance.currentUser
        profileImgView.sd_setImage(with: URL(string: user?.image ?? "" ), placeholderImage: placeHolderImage, options: .forceTransition)
        lblName.text = user?.name
        lblEmail.text = user?.email
    }
    
    //MARK:- Supporting Functions
    
    @objc func handleDashobardView(sender: UITapGestureRecognizer){
        switch sender.view?.tag {
        case 1:
            print("1")
        case 2:
            print("2")
        case 3:
            print("3")
        case 4:
            print("4")
        default:
            print("5")
            let popUp = PopUpMood()
            popUp.modalPresentationStyle = .overFullScreen
            popUp.modalTransitionStyle = .crossDissolve
            self.present(popUp, animated: true, completion: nil)
        }
    }
    
    
    //MARK:- Actions
    
    
}
