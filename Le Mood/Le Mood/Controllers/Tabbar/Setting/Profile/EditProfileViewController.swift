//
//  EditProfileViewController.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 24/05/2021.
//

import UIKit
import ProgressHUD
class EditProfileViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak  var imageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var updateBtnView: UIView!
    
    let user = DataService.instance.currentUser
    
    //MARK:- Controller Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleUpdateImage(sender:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapgesture)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        updateBtnView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
        
    }
    
    //MARK:- Supporting Functions
    
    @objc func handleUpdateImage(sender: UITapGestureRecognizer){
        self.showImagePicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {return}
        self.imageView.image = image
        ProgressHUD.show()
        DataService.instance.uploadProfilePicture(image: image) { [self](success, url) in
            if success {
                ProgressHUD.dismiss()
                let updateUser = UserModel(id: user?.id ?? "", name: user?.name ?? "", email: user?.email ?? "", image: url, gender: user?.gender ?? "", country: user?.country ?? "", region: user?.region ?? "")
                DataService.instance.updateUser(user: updateUser)
                DataService.instance.setCurrentUser(user: updateUser)
            }
            else{
                ProgressHUD.dismiss()
                Alert.showMsg(msg: "Something went wrong!. Please try again")
            }
        }
        
    }
    
    func updateUserProfile(){
        if txtName.text != "" {
            ProgressHUD.show()
            let updateUser = UserModel(id: user?.id ?? "", name: txtName.text!, email: user?.email ?? "", image: user?.image ?? "", gender: user?.gender ?? "", country: user?.country ?? "", region: user?.region ?? "")
            DataService.instance.updateUser(user: updateUser)
            DataService.instance.setCurrentUser(user: updateUser)
            txtName.text = ""
            ProgressHUD.dismiss()
            Alert.showMsg(msg: "Name successfully updated")
        }
        else
        {
            Alert.showMsg(msg: "Please Enter your new name")
        }
    }
    
    //MARK:- Actions
    
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.popViewController()
    }
    
    @IBAction func btnUpdateTapped(_ sender: Any){
        updateUserProfile()
    }
}
