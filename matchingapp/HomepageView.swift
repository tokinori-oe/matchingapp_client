//
//  HomepageView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/01.
//

import SwiftUI

struct HomepageView: View {
    @EnvironmentObject var wholeappafterloginmodel : WholeAppAfterLoginModel
    @State private var userID : Int?
    
    var body: some View {
        NavigationStack{
            TabView(selection: $wholeappafterloginmodel.selectedTag) {
                AccountListView().tabItem { Button("アカウント情報"){
                    
                }
                }.tag(1)
                MatchUpView().tabItem { Text("マッチアップ") }.tag(2)
                NotificationView().tabItem { Text("通知")}.tag(3)
                ChatView().tabItem{Text("チャット")}.tag(4)
                FeedView().tabItem{Text("ホーム")}.tag(5)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $wholeappafterloginmodel.GoToProfileChangeView){
                ProfileChangeView()
            }
            .navigationDestination(isPresented: $wholeappafterloginmodel.GoToLogout){
                LogoutLoadingView()
            }
            

            //.navigationBarHidden(true)
        }
    }
    
    
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}
