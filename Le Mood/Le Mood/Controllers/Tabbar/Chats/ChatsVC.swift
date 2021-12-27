//
//  ChatsVC.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 23/06/2021.
//

import UIKit
import LZViewPager
class ChatsVC: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var viewPager: LZViewPager!
    private var subControllers:[UIViewController] = []
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewPager()

    }

    func setupViewPager(){
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.hostController = self
    
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        viewPager.tintColor = #colorLiteral(red: 0.5076961517, green: 0.2106034458, blue: 0.2362745106, alpha: 1)
        let vc1 = mainStoryboard.instantiateViewController(withIdentifier: "MyChatsVC") as! MyChatsVC
        vc1.title = "My Chats"
        let vc2 = mainStoryboard.instantiateViewController(withIdentifier: "RandomChatVC") as! RandomChatVC
        vc2.title = "Random Chat"
        subControllers = [vc1, vc2]
        viewPager.reload()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewPager.roundCorners(corners: [.topLeft, .topRight], radius: 20)        
    }
}

extension ChatsVC: LZViewPagerDelegate, LZViewPagerDataSource{
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
    
    
  
    func colorForIndicator(at index: Int) -> UIColor {
        return #colorLiteral(red: 0, green: 0.3716039062, blue: 0.5234339833, alpha: 1)
    }
  
    func heightForIndicator() -> CGFloat {
        return 4
    }

    
}
