//
//  HomeViewController.swift
//  instagram
//
//  Created by Ayman Eldeeb on 3/20/18.
//  Copyright © 2018 Ayman Eldeeb. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet weak var tabelView: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        loadPosts()
    }
    
    func loadPosts() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("posts").observe(DataEventType.childAdded) { (dataSnapshot: DataSnapshot) in
            if let postsDic = dataSnapshot.value as? [String: Any] {
                let photoUrl = postsDic["postUrl"] as? String ?? ""
                let caption  = postsDic["caption"] as? String ?? ""
                let post = Post(photoUrl: photoUrl, caption: caption)
                self.posts.append(post)
                self.tabelView.reloadData()
            }
        }
    }
    
    @IBAction func logOut_TouchUpInside(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            print(signOutError)
        }
        
        let startStoryboard = UIStoryboard(name: "Start", bundle: nil)
        let signInStoryboar = startStoryboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInStoryboar, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
    
}























