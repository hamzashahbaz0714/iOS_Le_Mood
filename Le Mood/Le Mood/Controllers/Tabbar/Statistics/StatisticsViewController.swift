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
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var countryArr = [Any]()
    
    var moodArr = [MoodModel]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK:- Controller Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTodayMood()
        let user = DataService.instance.currentUser
        profileImgView.sd_setImage(with: URL(string: user?.image ?? "" ), placeholderImage: placeHolderImage, options: .forceTransition)
        lblName.text = user?.name
        lblEmail.text = user?.email
        //        getStatistics(country: DataService.instance.currentUser.country, state: DataService.instance.currentUser.region)
        getStatistics()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        statisticsViews.forEach { (view) in
            view.roundCorners(corners: [.topRight, .bottomLeft], radius: 18)
        }
        
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
    
    
    
    func getStatistics(){
        ProgressHUD.show()
        DataService.instance.getMoodStatistics { (success, mood, coutry) in
            if success {
                ProgressHUD.dismiss()
                self.moodArr = mood!
                let uniqueOrdered = Array(NSOrderedSet(array: coutry!))
                print(uniqueOrdered)
                self.countryArr = uniqueOrdered
                self.tableView.reloadData()
                
            }
            else
            {
                ProgressHUD.dismiss()
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
    
    
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as! StatCell
        let countries = countryArr[indexPath.row] as? String
        cell.lblCityName.text = countries
        var moodValue = 0
        var totalCountries = 0
        for i in 0..<moodArr.count {
            if countries == moodArr[i].country {
                moodValue = moodValue + moodArr[i].moodValue
                print(moodValue)
                totalCountries =  totalCountries + 1
                
            }
            
        }

        let avg = moodValue / totalCountries
        cell.lblMoodValue.text = "\(avg)%"
        
        if (avg <= 100 && avg > 80) {
            cell.moodImgView.image = UIImage(named: "5")
        } else if (avg <= 80 && avg > 60) {
            cell.moodImgView.image = UIImage(named: "4")
        } else if (avg <= 60 && avg > 40) {
            cell.moodImgView.image = UIImage(named: "3")
        } else if (avg <= 40 && avg > 20) {
            cell.moodImgView.image = UIImage(named: "2")
        } else {
            cell.moodImgView.image = UIImage(named: "1")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
