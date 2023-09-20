//
//  LoginView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/01.
//

import SwiftUI


struct LoginView: View {
    @State var username = ""
    @State var password=""
    @State var message=""
    @State var isLoggedin = false
    @StateObject var wholeappafterloginmodel = WholeAppAfterLoginModel()
    
    var body: some View {
        NavigationStack{
                VStack{
                    Text(message)
                        .foregroundColor(Color.red)
                    Text("ログイン")
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 24.0)
                        .font(.system(size: 25))
                        .foregroundColor(Color.black)
                    Text("ユーザー名")
                        .multilineTextAlignment(.center)
                        .padding(.trailing, 162.0)
                        .foregroundColor(Color.black)
                    TextField("username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .frame(width: 250)
                    Text("パスワード")
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 162.0)
                        .foregroundColor(Color.black)
                    TextField("password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .frame(width: 250)
                    Button("送信", action:send_email)
                        .buttonBorderShape(.roundedRectangle)
                        .buttonStyle(.borderedProminent)
                    NavigationLink(destination: SignupView()) {
                        Text("アカウント作成はこちら")
                            .foregroundColor(Color.blue)
                            .padding(.top, 0.1)
                        
                    }
                    NavigationLink(destination: PasswordchangeView()) {
                        Text("パスワードを忘れた方はこちら")
                            .foregroundColor(Color.blue)
                            .padding(.top, 0.1)
                        
                }
            }
                .navigationDestination(isPresented: $isLoggedin){
                LoginLoadingView()
                .environmentObject(wholeappafterloginmodel)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func send_email(){
        guard let url = URL(string:"http://127.0.0.1:8000/api/login/")else{
            return
        }
        
        let login_info:[String:Any]=[
            "username":username,
            "password":password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: login_info)
        
        //HTTPリクエストを送信
        URLSession.shared.dataTask(with: request) { data, response, error in
            // data, response, error はここで使用可能
            if let data = data {
                // レスポンスの処理
                if let responseString = String(data: data, encoding: .utf8){
                    
                    if responseString.contains("Invalid credentials"){
                            message = "ユーザー名またはパスワードが間違っています。"
                            username=""
                            password=""
                    }
                    else{
                        if let tokenData = responseString.data(using: .utf8){
                            if let tokenJson = try? JSONSerialization.jsonObject(with: tokenData, options: []) as? [String:Any], let token = tokenJson["token"] as? String{
                                DispatchQueue.main.async{
                                    let authToken = token
                                    UserDefaults.standard.set(authToken, forKey: "AuthToken")
                                    isLoggedin = true
                                    //ここにアカウントidを得る関数
                                    //ここにアカウントidを用いてwebsocket接続をする
                                }
                            }
                        }
                    }
                }
            }
        }.resume()
        
    }
}
