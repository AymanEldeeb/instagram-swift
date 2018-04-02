//
//  AuthService.swift
//  instagram
//
//  Created by Ayman Eldeeb on 3/23/18.
//  Copyright © 2018 Ayman Eldeeb. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onFail: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onFail(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    static func signUp(imageData: Data, username:String, email: String, password: String, onSuccess: @escaping () -> Void, onFail: @escaping (_ errorMessage: String?) -> Void){
        //add user to authintication list that can edit database
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onFail(error!.localizedDescription)
                return
            }
            
            //add image to Firebase Storage
            let rootStorageRef = Config.STORAGE_ROOT_REF
            let newProfileImageRef = rootStorageRef.child("profile_images").child(user!.uid)
            newProfileImageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                let newProfileImageUrl = metadata?.downloadURL()?.absoluteString
                
                //call function that add new user on Firebase Database
                self.addNewUser(uid: user!.uid, profileImageUrl: newProfileImageUrl!, username: username, email: email, onSuccess: onSuccess)
            })
        }
    }
    
    //add new user to Firebase Database
    static func addNewUser(uid: String, profileImageUrl: String, username: String, email: String, onSuccess: @escaping () -> Void) {
        let rootRef  = Database.database().reference()
        let usersRef = rootRef.child("users")
        let newUserRef  = usersRef.child(uid)
        newUserRef.setValue(["username": username, "email": email, "profileImage": profileImageUrl])
        onSuccess()
    }
}

