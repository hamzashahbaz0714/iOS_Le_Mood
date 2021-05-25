//
//  LoginViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 20/05/2021.
//

import UIKit
import ProgressHUD
import Firebase
class LoginViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLoginMethod()
    }
    
    
    //MARK:- Supporting Functions
    
    func autoLoginMethod(){
        ProgressHUD.show()
        if Auth.auth().currentUser != nil {
            DataService.instance.getUserOfID(userID: Auth.auth().currentUser?.uid ?? "") { (success, user) in
                ProgressHUD.dismiss()
                if success {
                    DataService.instance.setCurrentUser(user: user!)
                    let controller: TabbarViewController = TabbarViewController.initiateFrom(Storybaord: .Main)
                    self.pushController(contorller: controller, animated: true)
                }
                
            }
        }
        else{
            ProgressHUD.dismiss()
        }
    }
    
    func handleSigIn(){
        if txtEmail.text != "" && txtPassword.text != "" {
            ProgressHUD.show()
            AuthService.instance.loginUserWithEmail(email: txtEmail.text!, password: txtPassword.text!) { (success, error) in
                if success {
                    DataService.instance.getUserOfID(userID: Auth.auth().currentUser!.uid) { (success, user) in
                        DataService.instance.setCurrentUser(user: user!)
                        ProgressHUD.dismiss()
                        let controller: TabbarViewController = TabbarViewController.initiateFrom(Storybaord: .Main)
                        self.pushController(contorller: controller, animated: true)
                    }
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
            ProgressHUD.showError("Please Fill the all requiremnet!...")
        }
    }
    
    
    //MARK:- Actions
    
    @IBAction func btnDontHaveAnAccountTapped(_ sender: Any){
        let controller: SignupViewController = SignupViewController.initiateFrom(Storybaord: .Main)
        self.pushController(contorller: controller, animated: true)
    }
    
    @IBAction func btnForgotTapped(_ sender: Any){
        Alert.alertWithTextField(title: "Reset Password \n", message: "We will send a password reset link to your email", placeholder: "Enter your register email") { result in
            print(result)
            if result == "" {
                Alert.showMsg(title: "Error", msg: "Please enter your email", btnActionTitle: "OK")
                
            }
            else
            {
                ProgressHUD.show()
                Auth.auth().sendPasswordReset(withEmail: result) { (error) in
                    ProgressHUD.dismiss()
                    if error == nil {
                        Alert.showMsg(title: "Done \n", msg: "Your password reset link was sent your email address!", btnActionTitle: "OK")
                        
                    }
                    else
                    {
                        Alert.showMsg(title: "Error \n", msg: error?.localizedDescription ?? "", btnActionTitle: "OK")
                        
                    }
                }
            }
        }
    }
    
    @IBAction func btnSignInTapped(_ sender: Any){
        
        handleSigIn()
    }
}
