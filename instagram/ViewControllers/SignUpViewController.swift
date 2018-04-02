//
//  SignUpViewController.swift
//  instagram
//
//  Created by Ayman Eldeeb on 3/19/18.
//  Copyright © 2018 Ayman Eldeeb. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    var selectedProfileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nameBottomLayer = CALayer()
        nameBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        nameBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/200, alpha: 1.0).cgColor
        nameTextField.layer.addSublayer(nameBottomLayer)
        nameTextField.attributedPlaceholder = NSAttributedString(string: nameTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        
        let emailBottomLayer = CALayer()
        emailBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        emailBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/200, alpha: 1.0).cgColor
        emailTextField.layer.addSublayer(emailBottomLayer)
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        
        let passwordBottomLayer = CALayer()
        passwordBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        passwordBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/200, alpha: 1.0).cgColor
        passwordTextField.layer.addSublayer(passwordBottomLayer)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        
        //Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        signUpButton.isEnabled = false
        handleTextField()
    }
    
    func handleTextField() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChanged() {
        guard let username = nameTextField.text, !username.isEmpty,
             let email = emailTextField.text, !email.isEmpty,
             let password = passwordTextField.text, !password.isEmpty
        else {
            signUpButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signUpButton.isEnabled = false
            return
        }
        
        signUpButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpButton.isEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func chooseProfileImage() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_onClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signUpButton_touchUpInside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Wait...", interaction: false)
        if let profileImg = self.selectedProfileImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            AuthService.signUp(imageData: imageData, username: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
                ProgressHUD.showSuccess("Success")
                self.performSegue(withIdentifier: "signUpToTabBarVC", sender: nil)
            }, onFail: { (error) in
                ProgressHUD.showError("Fail")
                print(error!)
            })
        }
    }
}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedProfileImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}














