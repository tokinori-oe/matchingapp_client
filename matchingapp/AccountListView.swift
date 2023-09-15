//
//  AccountListView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/07.
//

import SwiftUI

struct AccountListView: View {
    @EnvironmentObject var afterloginModel : AfterLoginModel
    @EnvironmentObject var accountcheckmodel: AccountCheckModel
    @State private var isAccessedToAccountCheck = false
    @State private var getInfoAboutAccount = false
    var body: some View {
        NavigationStack{
            if isAccessedToAccountCheck, getInfoAboutAccount{
                //後々Tableという機能を使って表を書くからプロフィールの情報はオブジェクト配列を使った方が良さそう
                let school = accountcheckmodel.school_name ?? "受け取れてないよん"
                VStack{
                    Text("school_name: \(school)")
                    Button("プロフィール編集はこちら"){
                        afterloginModel.GoToProfileChangeView = true
                    }
                }
                
            }
            else{
                Text("Error")
            }
        }
        .onAppear{
            checktoken()
        }
    }
    
    func checktoken(){
        guard let url = URL(string:"http://127.0.0.1:8000/api/account_check/")else{
            return
        }
        
        if let token = UserDefaults.standard.string(forKey: "AuthToken"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
            
            //HTTPリクエストを送信
            URLSession.shared.dataTask(with:request){data, response, error in
                if let data = data{
                    
                    do {
                        // JSONデコードを試行
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let userId = jsonObject["user_id"] as? Int {
                            DispatchQueue.main.async {
                                print("user_id: \(userId)")
                                accountcheckmodel.userID = userId // userIDを更新
                                isAccessedToAccountCheck = true
                                get_accountinfo()
                            }
                        }
                    } catch {
                        print("JSONデコードエラー: \(error)")
                                           
                    }
                }
            }.resume()
        }else{
            return
        }
    }
    
    func get_accountinfo(){
        
        let account_id = accountcheckmodel.userID ?? 0
        guard let getinfo_url = URL(string: "http://127.0.0.1:8000/api/get_accountinfo/?user_id=\(account_id)") else {
            return
        }

        if let id = accountcheckmodel.userID{
            var request = URLRequest(url: getinfo_url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request){data, response, error in
                if let error = error {
                        print("HTTPリクエストエラー: \(error)")
                        return
                    }
                if let data = data{
                    do {
                        // JSONデコードを試行
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            DispatchQueue.main.async {
                                if let error = jsonObject["error"]{
                                    getInfoAboutAccount = false
                                    print(error)
                                }
                                else{
                                    accountcheckmodel.school_name = jsonObject["school_name"] as? String
                                    accountcheckmodel.faculty = jsonObject["faculty"] as? String
                                    accountcheckmodel.department = jsonObject["department"] as? String
                                    accountcheckmodel.hobbies = jsonObject["hobbies"] as? String
                                    accountcheckmodel.profile = jsonObject["profile"] as? String
                                    accountcheckmodel.age = jsonObject["age"] as? Int
                                    accountcheckmodel.gender = jsonObject["gender"] as? String
                                    accountcheckmodel.grade = jsonObject["grade"] as? String
                                    getInfoAboutAccount=true
                                }
                            }
                        }
                    } catch {
                        print("JSONデコードエラー: \(error)")
                    }
                }
            }.resume()
        }else{
            return
        }
        
    }
}

struct AccountListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListView()
    }
}
