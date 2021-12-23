//
//  RandomChatSelectVC.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 23/06/2021.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class RandomChatSelectVC: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSelectLanguage: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchBtnView: UIView!
    @IBOutlet weak var randomBtnView: UIView!
    @IBOutlet weak var selectedMoodName: UILabel!
    @IBOutlet weak var selectMoodImg: UIImageView!
    @IBOutlet weak var moodeSlider: UISlider!
    
    let kItemPadding = 15
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedMoodName.text = "Excited"
        moodeSlider.value = 100
        let bubbleLayout = MICollectionViewBubbleLayout()
        collectionViewHeight.constant = 0
        bubbleLayout.minimumLineSpacing = 10.0
        bubbleLayout.minimumInteritemSpacing = 10.0
        bubbleLayout.delegate = self
        collectionView.setCollectionViewLayout(bubbleLayout, animated: false)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        btnSelectLanguage.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        searchBtnView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        randomBtnView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        
    }
    
    //MARK:- Supporting Functions
    
    
    //MARK:- Actions
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
    
    @IBAction func didChangedSliderValue(_ sender: UISlider) {
        
        if moodeSlider.value <= 100  && moodeSlider.value >= 80{
            selectMoodImg.image = UIImage(named: "Emoji_5")
            selectedMoodName.text = "Excited"
        }
        else if moodeSlider.value <= 80  && moodeSlider.value >= 60 {
            selectMoodImg.image = UIImage(named: "Emoji_4")
            selectedMoodName.text = "Blush"
        }
        else if moodeSlider.value <= 60  && moodeSlider.value >= 40 {
            selectMoodImg.image = UIImage(named: "Emoji_3")
            selectedMoodName.text = "Happy"
        }
        else if moodeSlider.value <= 40  && moodeSlider.value >= 20  {
            selectMoodImg.image = UIImage(named: "Emoji_2")
            selectedMoodName.text = "Sad"
        }
        else
        {
            selectMoodImg.image = UIImage(named: "Emoji_1")
            selectedMoodName.text = "Angry"
        }
    }
    
    @objc func handleLanguageDelete(sender:UIButton){
        if self.appdelegate.selectLanguage.count == 1 {
            appdelegate.selectLanguage = appdelegate.selectLanguage.filter { $0 != appdelegate.selectLanguage[sender.tag]}
            self.collectionViewHeight.constant = 0
            self.collectionView.reloadData()
            return
        }
        appdelegate.selectLanguage = appdelegate.selectLanguage.filter { $0 != appdelegate.selectLanguage[sender.tag]}
        self.collectionView.reloadData()
    }
    
    @IBAction func btnSelectLanguageTapped(_ sender: Any){
        let controller: LanguagesViewController = LanguagesViewController.initiateFrom(Storybaord: .Main)
        controller.iscomeFromSelectLanugae = true
        controller.delegateLanguage = self
        self.pushController(contorller: controller, animated: true)
    }
    
    @IBAction func btnSearchTapped(_ sender: Any){
        if appdelegate.selectLanguage.count == 0{
            return
        }
        ProgressHUD.show()
        DataService.instance.searchLanguageBaseFriend(language: appdelegate.selectLanguage) { [self] (success, friends) in
                if success {
                    ProgressHUD.dismiss()
                    var newArr = friends
                    newArr?.shuffle()
                    if newArr?.count ?? 0 > 0 {

                        ProgressHUD.dismiss()
                        let controller: MessagesVC = MessagesVC.initiateFrom(Storybaord: .Main)
                        let uid1 = Auth.auth().currentUser!.uid
                        let uid2 = newArr?[0].id
                        if(uid1 > uid2 ?? ""){
                            controller.chatID = (uid1+(uid2 ?? ""))
                        }
                        else{
                            controller.chatID = ((uid2 ?? "")+uid1)
                        }
                        rID = newArr?[0].id ?? ""
                        controller.passRecieverUser = newArr?[0]
                        controller.isComefromRandomORMyCHat = true
                        self.pushController(contorller: controller, animated: true)
                    }
                    else
                    {
                        Alert.showWithTwoActions(title: "Oops", msg: "No user found against \(appdelegate.selectLanguage) language. Would you like to change language?", okBtnTitle: "Yes", okBtnAction: {
                        }, cancelBtnTitle: "No") {
                        }
                    }
                }
                else
                {
                    ProgressHUD.dismiss()
                    Alert.showMsg(msg: "Something went wrong. Please try again")
                }
            }

    }
}



extension RandomChatSelectVC: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appdelegate.selectLanguage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "languageSelectConfirmCell", for: indexPath) as! languageSelectConfirmCell
        cell.lbltitleText.text = appdelegate.selectLanguage[indexPath.row] as String
        cell.btnCross.addTarget(self, action: #selector(handleLanguageDelete(sender:)), for: .touchUpInside)
        cell.btnCross.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension RandomChatSelectVC: MICollectionViewBubbleLayoutDelegate{
    
    func collectionView(_ collectionView:UICollectionView, itemSizeAt indexPath:NSIndexPath) -> CGSize
    {
        let title = appdelegate.selectLanguage[indexPath.row] as String
        var size = title.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 13)!])
        size.width = CGFloat(ceilf(Float(size.width + CGFloat(kItemPadding * 2)+40)))
        size.height = 40
        
        //...Checking if item width is greater than collection view width then set item width == collection view width.
        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        
        return size;
    }
}

extension RandomChatSelectVC: dataPass {
    func languages(select: Bool) {
        DispatchQueue.main.async {
            if self.appdelegate.selectLanguage.count == 0 {
                self.collectionViewHeight.constant = 0
                self.collectionView.reloadData()
                return
            }
            
            self.collectionView.reloadData()
            self.collectionViewHeight.constant = 150
        }
    }
}
