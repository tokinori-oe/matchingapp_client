//
//  UserProfileData.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/11.
//

import Foundation
//Decodableプロトコルを使用することで、外部データをSwiftのデータ構造に簡単に変換できる
struct UserProfileData: Identifiable,Decodable{
    var id: Int
    //var username: String
    var school_name: String
    var faculty: String
    var department: String
    var grade: String
    var hobbies: String?
    var age: Int?
    var profile: String?
}

struct DataOfRequest{
    var content: String?
    //var username: String?
    var school_name: String?
    var faculty: String?
    var department: String?
    var grade: String?
    var hobbies: String?
    var age: Int?
    var profile: String?
    var date: Date?
}

//chatの機能ができたら再度検討
struct DataOfChat{
    var content :String?
    //var username: String?
    var date: Date?
}

struct PushNotificationData{
    var content: String?
    //o59o5ao4avar username: String?
}
