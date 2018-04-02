//
//  config.swift
//  instagram
//
//  Created by Ayman Eldeeb on 3/23/18.
//  Copyright © 2018 Ayman Eldeeb. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct Config {
    static var STORAGE_ROOT_REF = Storage.storage().reference()
}
