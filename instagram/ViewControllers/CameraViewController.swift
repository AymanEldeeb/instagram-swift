//
//  CameraViewController.swift
//  instagram
//
//  Created by Ayman Eldeeb on 3/20/18.
//  Copyright © 2018 Ayman Eldeeb. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ImagePicker

class CameraViewController: UIViewController, ImagePickerDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    var selectedPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(choosePhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handelPost()
    }
    
    func handelPost(){
        if selectedPhoto != nil {
            shareButton.isEnabled = true
            shareButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            resetButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
            shareButton.backgroundColor = UIColor.lightGray
            resetButton.isEnabled = false
        }
    }
    
    @objc func choosePhoto() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }

    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 3
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        print("wrapper")
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        print("done")
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        print("cancel")
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        ProgressHUD.show("Wait...", interaction: false)
        if let profileImg = self.selectedPhoto, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            //add image to Firebase Storage
            let uid = Auth.auth().currentUser?.uid
            let postIdString = UUID().uuidString
            let rootStorageRef = Config.STORAGE_ROOT_REF
            let newPostRef = rootStorageRef.child("posts").child(postIdString)
            newPostRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError("Fail")
                    return
                }
                let newPostUrl = metadata?.downloadURL()?.absoluteString
                
                //call function that add new user on Firebase Database
                self.addNewPost(uid: uid!, newPostUrl: newPostUrl!)
            })
        } else {
            ProgressHUD.showError("Photo can't be empty")
            print("Photo can't be empty")
        }
    }
    
    func addNewPost(uid: String, newPostUrl: String) {
        let rootRef  = Database.database().reference()
        let usersRef = rootRef.child("users")
        let userPostsRef  = usersRef.child(uid).child("posts")
        let newPostRef = userPostsRef.childByAutoId()
        newPostRef.setValue(["postUrl" : newPostUrl, "caption": captionTextView.text!], withCompletionBlock: { (error, ref) in
            if error != nil {
                ProgressHUD.showError("Fail")
                return
            }
            ProgressHUD.showSuccess("Success")
            self.reset()
            self.tabBarController?.selectedIndex = 0
        })
    }
    
    func reset() {
        captionTextView.text = ""
        photo.image = UIImage(named: "placeHolder")
        selectedPhoto = nil
    }
    @IBAction func resetButton_TouchUpInside(_ sender: Any) {
        reset()
        handelPost()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        handelPost()
    }
}

extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedPhoto = image
            photo .image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}















