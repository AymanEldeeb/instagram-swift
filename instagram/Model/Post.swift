//
//  Post.swift
//  instagram
//
//  Created by Ayman Eldeeb on 3/27/18.
//  Copyright © 2018 Ayman Eldeeb. All rights reserved.
//

import Foundation

class Post {
    var photoUrl: String
    var caption: String
    init(photoUrl: String, caption: String) {
        self.photoUrl = photoUrl
        self.caption = caption
    }
}
