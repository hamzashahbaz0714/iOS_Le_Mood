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
    
    var gender: String?
    
    
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
        txtCountry.optionArray = ["Pakistan","India","China","Iran","Iraq","Saudia", "Arabia","United States"]
        txtCountry.didSelect { (selectedText, row, number) in
            self.txtCountry.text = selectedText
        }
        txtReigion.optionArray = ["Punjab","Sindh","Balochistan","Khyber Pakhtun"]
        txtReigion.didSelect { (selectedText, row, number) in
            self.txtReigion.text = selectedText
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
                    ProgressHUD.show()
                    AuthService.instance.registerUserWithEmail(withEmail: txtEmail.text!, andPassword: txtPassword.text!) { [self] (success, error) in
                        if success {
                            AuthService.instance.loginUserWithEmail(email: txtEmail.text!, password: txtCPassword.text!) { (succes, error) in
                                if success {
                                    let user = User(id: Auth.auth().currentUser?.uid ?? "" , name: txtName.text!, email: txtEmail.text!, image: "", gender: "male", country: txtCountry.text!, region: txtReigion.text!)
                                    DataService.instance.updateUser(user: user)
                                    ProgressHUD.dismiss()
                                    let controller: TabbarViewController = TabbarViewController.initiateFrom(Storybaord: .Main)
                                    self.pushController(contorller: controller, animated: true)
                                }
                                else
                                {
                                    ProgressHUD.dismiss()
                                    Alert.showMsg(title: "Error!", msg: error!.localizedDescription, btnActionTitle: "OK")
                                }
                            }
                            
                        }
                        else
                        {
                            ProgressHUD.dismiss()
                            Alert.showMsg(title: "Error!", msg: "Please try again!...", btnActionTitle: "OK")
                        }
                    }
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
//
//extension SignupViewController: UITextFieldDelegate {
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == txtCountry || textField == txtReigion {
//            self.view.endEditing(true)
//        }
//        return true
//    }
//}
