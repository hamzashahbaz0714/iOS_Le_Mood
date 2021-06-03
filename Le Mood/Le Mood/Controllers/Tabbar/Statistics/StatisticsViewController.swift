//
//  StatisticsViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 25/05/2021.
//

import UIKit
import ProgressHUD
import iOSDropDown

class StatisticsViewController: UIViewController {
    
    //MARK:- Propeties
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet var statisticsViews: [UIView]!
    @IBOutlet weak var lblMoodValue: UILabel!
    @IBOutlet weak var moodImageStat: UIImageView!
    @IBOutlet weak var lblMoodValueStat: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var txtCountry: DropDown!
    @IBOutlet weak var txtState: DropDown!
    @IBOutlet weak var btnShowStatView: UIView!
    

    
    var countryArr = [String]()
    var statesArr = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK:- Controller Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDropDown()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTodayMood()
        let user = DataService.instance.currentUser
        profileImgView.sd_setImage(with: URL(string: user?.image ?? "" ), placeholderImage: placeHolderImage, options: .forceTransition)
        lblName.text = user?.name
        lblEmail.text = user?.email
        getStatistics(country: DataService.instance.currentUser.country, state: DataService.instance.currentUser.region)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        statisticsViews.forEach { (view) in
            view.roundCorners(corners: [.topRight, .bottomLeft], radius: 18)
        }
        btnShowStatView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
 
    }
    
    //MARK:- Supporting Functions
    
    private func generateRandomEntries() -> [PointEntry] {
        var result: [PointEntry] = []
        for i in 0..<100 {
            let value = Int(arc4random() % 100)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            
            result.append(PointEntry(value: value, label: formatter.string(from: date)))
        }
        return result
    }
    
    func configureDropDown(){
        appDelegate.countries?.countries?.forEach({ (country) in
            countryArr.append(country.country ?? "")
        })
        txtCountry.optionArray = countryArr
        txtCountry.didSelect { [self](selectedText, row, number) in
            statesArr.removeAll()
            self.txtState.text = ""
            self.txtCountry.text = selectedText
            appDelegate.countries?.countries?[row].states?.forEach({ (states) in
                statesArr.append(states)
            })
            txtState.optionArray = statesArr
            txtState.didSelect { (selectedText, row, number) in
                self.txtState.text = selectedText
            }
        }
    }
    
    func getStatistics(country: String,state: String){
        ProgressHUD.show()
        DataService.instance.getMoodStatistics(country: country, state: state) { [weak self](success, mood) in
            if success {
                var value = 0
                ProgressHUD.dismiss()
                if mood?.count ?? 0 > 0 {
                    mood?.forEach({ (moodValue) in
                        value = value + moodValue.moodValue
                    })
                    let average = value / (mood?.count ?? 0)
                    self?.lblMoodValueStat.text = "\(average)"
                    if average <= 100  && average >= 80{
                        self?.moodImageStat.image = UIImage(named: "5")
                        
                    }
                    else if average <= 80  && average >= 60 {
                        self?.moodImageStat.image = UIImage(named: "4")
                    }
                    else if average <= 60  && average >= 40 {
                        self?.moodImageStat.image = UIImage(named: "3")
                    }
                    else if average <= 40  && average >= 20  {
                        self?.moodImageStat.image = UIImage(named: "2")
                    }
                    else
                    {
                        self?.moodImageStat.image = UIImage(named: "1")
                    }
                }
            }
            else
            {
                ProgressHUD.dismiss()
                Alert.showMsg(msg: "NO Record Found again this country and state")
                
            }
        }
    }
    
    func getTodayMood(){
        if appDelegate.isMoodFetched == true {
            let user = DataService.instance.currentUser
            if user?.lastMoodDate != "" && user?.lastMoodDate == getCurrentDate() && user?.lastMoodDate != "Not found"{
                self.appDelegate.isMoodFetched = true
                self.lblMoodValue.text = "\(user?.moodValue ?? 0)"
                self.lblMoodValue.font = UIFont(name: "Poppins-Medium", size: 32)
                switch user?.moodType {
                case "Angry":
                    self.moodImage.image = #imageLiteral(resourceName: "emoji1")
                case "Sad":
                    self.moodImage.image = #imageLiteral(resourceName: "emoji2")
                case "Happy":
                    self.moodImage.image = #imageLiteral(resourceName: "emoji4")
                case "Blush":
                    self.moodImage.image = #imageLiteral(resourceName: "emoji3")
                default:
                    self.moodImage.image = #imageLiteral(resourceName: "emoji_think")
                }
            }
        }
        else{
            self.moodImage.image = UIImage(named: "icon_submit_mood")
            self.lblMoodValue.font = UIFont(name: "Poppins-Medium", size: 18)
            self.lblMoodValue.text = "Submit your mood"
        }
    }
    
    
    
    //MARK:- Actions
    
    @IBAction func btnShowStatTapped(_ sender: Any){
        if txtCountry.text != "" && txtState.text != "" {
            getStatistics(country: txtCountry.text!, state: txtState.text!)
        }
        else
        {
            Alert.showMsg(msg: "Please select country and state to show statistics")
        }
    }
}
