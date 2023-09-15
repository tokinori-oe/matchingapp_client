//
//  MatchUpView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/08.
//

import SwiftUI

struct MatchUpView: View {
    @State var getRecommendationInfo = false
    @EnvironmentObject var afterloginModel : AfterLoginModel
    @EnvironmentObject var accountcheckmodel: AccountCheckModel
    @State private var userProfiles: [UserProfileData] = []
    @State private var isButtonClicked = false
    var body: some View {
        VStack{
            if getRecommendationInfo{
                ScrollView{
                    LazyVStack(alignment: .center, spacing: 20){
                        ForEach(userProfiles){UserProfileData in
                            EachRecommendationView(profile:UserProfileData)
                        }
                    }
                }.padding(.horizontal)
            }
            else{
                Text("Error")
            }
        }.alert(isPresented: $isButtonClicked){
            Alert(title: Text("本当に送信しますか？"),
                  primaryButton: .default(Text("送信"), action: {
                okAction()
            }),
                  secondaryButton: .cancel(Text("キャンセル"),action:{})
            )
        }
        .onAppear{
           checkRecommendation()
        }
    }
    
    func okAction(){
        
    }
    
    func checkRecommendation(){
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
                                GetRecommendation()
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
    
    func GetRecommendation(){
        
        let account_id = accountcheckmodel.userID ?? 0
        guard let get_recommendation_url = URL(string:"http://127.0.0.1:8000/api/get_recommendation/?user_id=\(account_id)")else{
            return
        }
        
        if let id = accountcheckmodel.userID{
            var request = URLRequest(url: get_recommendation_url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request){data, response, error in
                if let error = error {
                            print("HTTPリクエストエラー: \(error)")
                            return
                }
                
                if let data = data{
                    do{
                        let decoder = JSONDecoder()
                        let userProfiles = try decoder.decode([UserProfileData].self, from: data)
                        
                        DispatchQueue.main.async {
                            self.userProfiles = userProfiles
                            print(self.userProfiles)
                            getRecommendationInfo = true
                        }
                    }
                    catch{
                        print("JSONデコードエラー: \(error)")
                    }
                }
            }.resume()
        }
        else{
            return
        }
        
    }
}

struct MatchUpView_Previews: PreviewProvider {
    static var previews: some View {
        MatchUpView()
    }
}
