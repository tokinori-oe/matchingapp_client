//
//  ShareInstance.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/02.
//

import Foundation


class AuthViewModel: ObservableObject{
    
    @Published var username: String = ""
    @Published var School: String = ""
    @Published var password: String = ""
    @Published var faculty: String = ""
    @Published var department: String = ""
    @Published var age: String = ""
    @Published var grade: String = ""
    @Published var hobbies: String = ""
    @Published var profile: String = ""
    @Published var email: String = ""
    @Published var gender: String = ""
    @Published var signback: Bool = false
    @Published var genderback: Bool = false
    @Published var schoolback: Bool = false
    @Published var facultyback: Bool = false
    @Published var otherback: Bool = false
    @Published var checkback: Bool = false
}
