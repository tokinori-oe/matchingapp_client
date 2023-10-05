//
//  MatchUpView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/08.
//

import SwiftUI

struct MatchUpView: View {
    @State var getRecommendationInfo = false
    @EnvironmentObject var wholeappafterloginmodel : WholeAppAfterLoginModel
    @State private var userProfiles: [UserProfileData] = []
    @State private var isButtonClicked = false
    @EnvironmentObject var websocketmanager : WebSocketManager
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
        }.alert(isPresented: $wholeappafterloginmodel.isRequestButtonClicked){
            Alert(title: Text("本当に送信しますか？"),
                  primaryButton: .default(Text("送信"), action: {
                okAction()
                wholeappafterloginmodel.isRequestButtonClicked = false
            }),
                  secondaryButton: .cancel(Text("キャンセル"),action:{
                wholeappafterloginmodel.isRequestButtonClicked = false
            })
            )
        }
        .onAppear{
            GetRecommendation()
            print(wholeappafterloginmodel.userID)
        }
    }
    
    func okAction(){
        }
    
    func GetRecommendation(){
        
        let account_id = wholeappafterloginmodel.userID ?? 0
        guard let get_recommendation_url = URL(string:"http://127.0.0.1:8000/api/get_recommendation/?user_id=\(account_id)")else{
            return
        }
        
        if let id = wholeappafterloginmodel.userID{
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
