//
//  CheckWholeInfoView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/04.
//

import SwiftUI

struct CheckWholeInfoView: View {
    @ObservedObject var authViewModel : AuthViewModel
    @State var isChecked = false
    @State var userID: Int?
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("アカウント情報を確認してください")
                HStack {
                    VStack{
                        VStack {
                            Text("ユーザーネーム")
                            Divider()
                            Text("メールアドレス")
                            Divider()
                            Text("学校")
                            Divider()
                            Text("学部")
                            Divider()
                            Text("学科")
                            Divider()
                        }
                        VStack{
                            Text("学年")
                            Divider()
                            Text("趣味")
                            Divider()
                            Text("年齢")
                            Divider()
                            Text("プロフィール")
                            Divider()
                            Text("性別")
                            Divider()
                            
                        }
                    
                }
                    VStack{
                        VStack {
                            Text(authViewModel.username)
                            Divider()
                            Text(authViewModel.email)
                            Divider()
                            Text(authViewModel.School)
                            Divider()
                            Text(authViewModel.faculty)
                            Divider()
                            Text(authViewModel.department)
                            Divider()
                        }
                        VStack{
                            Text(authViewModel.grade)
                            Divider()
                            Text(authViewModel.hobbies)
                            Divider()
                            Text(authViewModel.age)
                            Divider()
                            Text(authViewModel.profile)
                            Divider()
                            Text(authViewModel.gender)
                            Divider()
                        }
                    }
                    }
                    .padding()
                Button("登録する"){
                    registeraccount()
                }
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
            }
            .navigationDestination(isPresented: $isChecked){
                CheckDoneView()
            }
            .navigationDestination(isPresented: $authViewModel.checkback){
                OtherInfoView(authViewModel: authViewModel)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action:{
                        authViewModel.checkback = true
                    }){
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("戻る")
                        }
                    }
                }
            }
        }
    }
    func registeraccount(){
        //user登録のために送信する
        guard let url = URL(string:"http://127.0.0.1:8000/api/account_register/")else{
            return
        }
        
        let AccountData=[
            "username" : authViewModel.username,
            "email" : authViewModel.email,
            "password" : authViewModel.password,
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: AccountData)
        } catch {
            print("Error encoding user data: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                    print("HTTPリクエストエラー: \(error)")
                    return
                } //これはどういう意味
            if let data = data {
                do {
                    // JSONデコードを試行
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let userId = jsonObject["user_id"] as? Int {
                        print("user_id: \(userId)")
                        self.userID = userId // userIDを更新
                        registerprofile()
                    }
                } catch {
                    print("JSONデコードエラー: \(error)")
                }
            }
        }.resume()
    }
   
    
    func registerprofile(){
        guard let url = URL(string:"http://127.0.0.1:8000/api/profile_register/")else{
            return
        }
        
        let ProfileData: [String: Any] = [
            "user": userID,
            "school_name" : authViewModel.School,
            "faculty" : authViewModel.faculty,
            "department" : authViewModel.department,
            "grade" : authViewModel.grade,
            "hobbies" : authViewModel.hobbies,
            "profile" : authViewModel.profile,
            "gender" : authViewModel.gender,
            "age" : authViewModel.age
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ProfileData)
        } catch {
            print("Error encoding user data: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                    print("HTTPリクエストエラー: \(error)")
                    return
                }
            if let data = data{
                if let responseString = String(data: data, encoding: .utf8){
                    //ここで成功した場合とエラーした場合の処理
                    print("レスポンス: \(responseString)")
                    isChecked = true
                }
            }
        }.resume()
    }
}
