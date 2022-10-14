//
//  constant.swift
//  mainProject
//
//  Created by Bryan Kenneth on 12/10/22.
//

import FirebaseFirestore
import FirebaseAuth

let FR_REF = Firestore.firestore()
let FR_REF_USER = FR_REF.collection("users")

let AUTH_REF = Auth.auth()
let CURRENT_USER = AUTH_REF.currentUser

