//
//  SignupViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit
import Firebase
import iOSDropDown
import ProgressHUD

class SignupViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCPassword: UITextField!
    @IBOutlet weak var txtCountry: DropDown!
    @IBOutlet weak var txtReigion: DropDown!
    @IBOutlet var lblGender: [UILabel]!
    @IBOutlet var genderView: [UIView]!
    @IBOutlet var genderImages: [UIButton]!
    
    var countryArr = [String]()
    var statesArr = [String]()
    var gender: String?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderView.forEach { (views) in
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleMoodimages(sender:)))
            views.addGestureRecognizer(tapgesture)
        }
        configureDropDown()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        txtReigion.endEditing(true)
        txtCountry.endEditing(true)
    }
    
    //MARK:- Supporting Functions
    
    
    func configureDropDown(){
        appdelegate.countries?.countries?.forEach({ (country) in
            countryArr.append(country.country ?? "")
        })
        txtCountry.optionArray = countryArr
        txtCountry.didSelect { [self](selectedText, row, number) in
            statesArr.removeAll()
            self.txtCountry.text = selectedText
            appdelegate.countries?.countries?[row].states?.forEach({ (states) in
                statesArr.append(states)
            })
            txtReigion.optionArray = statesArr
            txtReigion.didSelect { (selectedText, row, number) in
                self.txtReigion.text = selectedText
            }
            
            
        }
    }
    
    @objc func handleMoodimages(sender: UITapGestureRecognizer){
        switch sender.view?.tag {
        case 1:
            self.gender = "male"
            lblGender[0].textColor = #colorLiteral(red: 0, green: 0.3716039062, blue: 0.5234339833, alpha: 1)
            lblGender[1].textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            lblGender[2].textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            genderImages[0].alpha = 1
            genderImages[1].alpha = 0.3
            genderImages[2].alpha = 0.3
        case 2:
            self.gender = "female"
            lblGender[1].textColor = #colorLiteral(red: 0, green: 0.3716039062, blue: 0.5234339833, alpha: 1)
            lblGender[0].textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            lblGender[2].textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            genderImages[1].alpha = 1
            genderImages[0].alpha = 0.3
            genderImages[2].alpha = 0.3
        default:
            self.gender = "other"
            lblGender[2].textColor = #colorLiteral(red: 0, green: 0.3716039062, blue: 0.5234339833, alpha: 1)
            lblGender[0].textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            lblGender[1].textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            genderImages[2].alpha = 1
            genderImages[0].alpha = 0.3
            genderImages[1].alpha = 0.3
        }
        
    }
    
    func handleSignUp(){
        
        if txtName.text != ""  && txtEmail.text != "" && txtCountry.text != "" && txtReigion.text != ""{
            if gender != nil {
                if txtPassword.text!.count >= 6 && txtCPassword.text!.count >= 6 && txtPassword.text == txtCPassword.text {
                    let controller: NumberViewController = NumberViewController.initiateFrom(Storybaord: .Main)
                    let user = UserModel(id: Auth.auth().currentUser?.uid ?? "" , name: txtName.text!, email: txtEmail.text!, phoneNumber: "", image: "", gender: gender ?? "male", country: txtCountry.text!, region: txtReigion.text!,moodId: "",moodType: "",moodValue: 0)
                    controller.passUser = user
                    controller.password = txtPassword.text!
                    self.pushController(contorller: controller, animated: true)
                }
                else if txtPassword.text != txtCPassword.text
                {
                    ProgressHUD.showError("Your Confirm password do not match with password!...")
                }
                else
                {
                    ProgressHUD.showError("Password Atleast six character or above!...")
                }
            }
            else
            {
                ProgressHUD.showError("Select your gender!...")
            }
        }
        else
        {
            ProgressHUD.showError("Please Fill the all requiremnet!...")
        }
        
    }
    
    //MARK:- Actions
    
    @IBAction func btnAlreadyHaveAnAccountTapped(_ sender: Any){
        self.popViewController()
    }
    
    @IBAction func btnSignupTapped(_ sender: Any){
        
        handleSignUp()
    }
    
}
