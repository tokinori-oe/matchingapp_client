//
//  UserProfileData.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/11.
//

import Foundation

struct UserProfileData: Identifiable,Decodable{
    var id: Int
    var school_name: String
    var faculty: String
    var department: String
    var grade: String
    var hobbies: String?
    var age: Int?
    var profile: String?
}
