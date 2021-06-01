//
//  VerificationViewController.swift
//  Akoya
//
//  Created by Wahab on 09/09/2020.
//  Copyright © 2020 Fast Net. All rights reserved.
//

import UIKit
import Firebase
import SVPinView
import ProgressHUD

class VerificationViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet var pinView:SVPinView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var topTitleLbl: UILabel!
    var option:String = ""
    var loginValue:String = ""
    var enterdPin : String?
    var number: String?
    var passUser: UserModel?
    var password: String?
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTitleLbl.text = "Please type the verification code sent to: \(passUser?.phoneNumber ?? "")"
        configurePinView()
    }
    
    //MARK:- Supporting Functions
    
    
    func configurePinView() {
        
        pinView.pinLength = 6
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 10
        pinView.textColor = UtilityManager().appThemeColor()
        pinView.borderLineColor = UtilityManager().appThemeColor()
        pinView.activeBorderLineColor = UtilityManager().appThemeColor()
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.style = .underline
        pinView.activeBorderLineThickness = 3
        pinView.fieldBackgroundColor = UIColor.clear
        pinView.activeFieldBackgroundColor = UIColor.clear
        pinView.fieldCornerRadius = 0
        pinView.activeFieldCornerRadius = 0
        pinView.placeholder = ""
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        
        pinView.font = UIFont(name: "Poppins-Medium", size: 22.0)!
        pinView.keyboardType = .phonePad
        
        //pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didFinishCallback = { pin in
            print("The entered pin is \(pin)")
            self.verifiyOtp(otp: pin)
        }
    }
    
    func handleSignup(){
        ProgressHUD.show()
        AuthService.instance.registerUserWithEmail(withEmail: passUser?.email ?? "", andPassword: password ?? "") { [self] (success, error) in
            if success {
                AuthService.instance.loginUserWithEmail(email: passUser?.email ?? "", password: password ?? "") { (succes, error) in
                    if success {
                        let user = UserModel(id: Auth.auth().currentUser!.uid, name: passUser?.name ?? "", email: passUser?.email ?? "", phoneNumber: passUser?.phoneNumber ?? "", image: passUser?.image ?? "", gender: passUser?.gender ?? "", country: passUser?.country ?? "", region: passUser?.region ?? "",moodId: "",moodType: "",moodValue: 0)
                        DataService.instance.updateUser(user: user)
                        DataService.instance.setCurrentUser(user: user)
                        ProgressHUD.dismiss()
                        let controller: TabbarViewController = TabbarViewController.initiateFrom(Storybaord: .Main)
                        self.pushController(contorller: controller, animated: true)
                    }
                    else
                    {
                        ProgressHUD.dismiss()
                        Alert.showWithCompletion(title: "Error", msg: error?.localizedDescription ?? "", btnActionTitle: "Ok") {
                            self.popTo(ViewController: LoginViewController.self)
                        }
                    }
                }
                
            }
            else
            {
                ProgressHUD.dismiss()
                Alert.showWithCompletion(title: "Error", msg: error?.localizedDescription ?? "", btnActionTitle: "Ok") {
                    self.popViewController()
                }
            }
        }
    }
    
    func verifiyOtp(otp: String){
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: otp)
        ProgressHUD.show()
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                ProgressHUD.dismiss()
                print(error.localizedDescription)
                self.popViewController()
                return
            }
            self.handleSignup()
        }
        
    }
    
    //MARK:- Actions
    
    
}
