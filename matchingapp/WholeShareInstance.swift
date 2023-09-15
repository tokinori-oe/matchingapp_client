//
//  WholeShareInstance.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/08.
//

import Foundation


class AfterLoginModel: ObservableObject{ //これは後々削除する
    @Published var isAcccessedToMatchUp = false
    @Published var selectedTag = 1
    @Published var GoToProfileChangeView = false
}

class AccountCheckModel: ObservableObject{ //これは後々削除する
    @Published var userID: Int?
    @Published var school_name: String? = ""
    @Published var faculty: String? = ""
    @Published var department: String? = ""
    @Published var hobbies :String? = ""
    @Published var profile :String? = ""
    @Published var age: Int?
    @Published var grade: String? = ""
    @Published var gender: String? = ""
}

//プロファイル情報とuserIDはダウンロード画面で取得する
class WholeAppAfterLoginModel: ObservableObject{
    @Published var isAcccessedToMatchUp = false
    @Published var selectedTag = 1
    @Published var GoToProfileChangeView = false
    @Published var userID: Int?
    @Published var school_name: String? = ""
    @Published var faculty: String? = ""
    @Published var department: String? = ""
    @Published var hobbies :String? = ""
    @Published var profile :String? = ""
    @Published var age: Int?
    @Published var grade: String? = ""
    @Published var gender: String? = ""
}