//
//  FriendsViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 26/05/2021.
//

import UIKit
import LZViewPager

class FriendsViewController: UIViewController {

    //MARK:- Properties
    @IBOutlet weak var viewPager: LZViewPager!
    private var subControllers:[UIViewController] = []
    var isComeFromLanguage = false

    
    //MARK:- Controller Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        setupViewPager()
    }
    
    //MARK:- Supporting Functions
    
    
    func setupViewPager(){
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.hostController = self
    
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        viewPager.tintColor = #colorLiteral(red: 0.5076961517, green: 0.2106034458, blue: 0.2362745106, alpha: 1)
        let vc1 = mainStoryboard.instantiateViewController(withIdentifier: "MoodFriendsViewController") as! MoodFriendsViewController
        vc1.title = "Friends"
        let vc2 = mainStoryboard.instantiateViewController(withIdentifier: "AllFriendsViewController") as! AllFriendsViewController
        if isComeFromLanguage == false{
            vc2.title = "All users"
            vc2.isComeFromLanguage = false
        }else{
            vc2.title = "Language users"
            vc2.isComeFromLanguage = true
        }
        subControllers = [vc1, vc2]
        viewPager.reload()
    }
    
    
    //MARK:- Actions
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
}


extension FriendsViewController: LZViewPagerDelegate, LZViewPagerDataSource{
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        //Customize your button styles here
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "TTCommons-Bold", size: 20)
        return button
    }
    
    
    func widthForButton(at index: Int) -> CGFloat {
        if isComeFromLanguage == false {
         return 80
        }
        return 140
    }
    func colorForIndicator(at index: Int) -> UIColor {
        return #colorLiteral(red: 0, green: 0.3716039062, blue: 0.5234339833, alpha: 1)
    }
    func widthForIndicator(at index: Int) -> CGFloat {
        return 70
    }
    func heightForIndicator() -> CGFloat {
        return 4
    }

    
}

