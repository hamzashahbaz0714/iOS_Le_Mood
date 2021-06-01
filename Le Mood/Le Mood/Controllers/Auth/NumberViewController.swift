//
//  PhoneViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 25/05/2021.
//

import UIKit
import ProgressHUD
import Firebase
import PhoneNumberKit

class NumberViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var txtNumber: PhoneNumberTextField!
    @IBOutlet weak var nextView: UIView!
    
    var passUser: UserModel?
    var password: String?
    
    //MARK:- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        txtNumber.withFlag = true
        txtNumber.withExamplePlaceholder = true
    }
    
    //MARK:- Suppoting Functions
    
    func sendOtpTONumber(){
        if txtNumber.text != "" {
            print(txtNumber.text!)
            ProgressHUD.show()
            PhoneAuthProvider.provider().verifyPhoneNumber("\(txtNumber.text!.replacingOccurrences(of: " ", with: ""))", uiDelegate: nil) { [self] (verificationID, error) in
                if error == nil {
                    ProgressHUD.dismiss()
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    let user = UserModel(id: Auth.auth().currentUser?.uid ?? "", name: passUser?.name ?? "", email: passUser?.email ?? "", phoneNumber: "\(txtNumber.text!)", image: passUser?.image ?? "", gender: passUser?.gender ?? "", country: passUser?.country ?? "", region: passUser?.region ?? "",moodId: "",moodType: "",moodValue: 0)
                    let controller:VerificationViewController = VerificationViewController.initiateFrom(Storybaord: .Main)
                    controller.passUser = user
                    controller.password = password
                    self.pushController(contorller: controller, animated: true)
                }
                else
                {
                    ProgressHUD.dismiss()
                    Alert.showMsg(msg: error?.localizedDescription ?? "")
                }
            }
        }
        else
        {
            ProgressHUD.dismiss()
            Alert.showMsg(msg: "Please Enter your number")
        }
    }
    
    //MARK:- Actions
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
    
    @IBAction func btnCountryCodeTapped(_ sender: Any){
        
    }
    @IBAction func btnNextTapped(_ sender: Any) {
        sendOtpTONumber()
    }
}

