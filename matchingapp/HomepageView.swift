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
    @ObservedObject var websocketmanager : WebSocketManager
    
    var body: some View {
        NavigationStack{
            TabView(selection: $wholeappafterloginmodel.selectedTag) {
                AccountListView(websocketmanager: websocketmanager).tabItem { Button("アカウント情報"){
                    
                }
                }.tag(1)
                MatchUpView(websocketmanager: websocketmanager).tabItem { Text("マッチアップ") }.tag(2)
                NotificationView(websocketmanager: websocketmanager).tabItem { Text("通知")}.tag(3)
                ChatView(websocketmanager: websocketmanager).tabItem{Text("チャット")}.tag(4)
                FeedView(websocketmanager: websocketmanager).tabItem{Text("ホーム")}.tag(5)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $wholeappafterloginmodel.GoToProfileChangeView){
                ProfileChangeView(websocketmanager: websocketmanager)
            }
            .navigationDestination(isPresented: $wholeappafterloginmodel.GoToLogout){
                LogoutLoadingView(websocketmanager: websocketmanager)
            }
            .navigationBarHidden(true)
        }
    }
    
    
}
