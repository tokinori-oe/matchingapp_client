//
//  AccountListView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/07.
//

import SwiftUI

struct AccountListView: View {
    @EnvironmentObject var wholeappafterloginmodel : WholeAppAfterLoginModel
    @State private var LogoutButtonClicked = false
    @EnvironmentObject var websocketmanager : WebSocketManager
    var body: some View {
        NavigationStack{
            if wholeappafterloginmodel.getInfoAboutAccount{
                //後々Tableという機能を使って表を書くからプロフィールの情報はオブジェクト配列を使った方が良さそう
                let school = wholeappafterloginmodel.school_name
                VStack{
                    Text("school_name: \(wholeappafterloginmodel.school_name ?? "エラー起きてるよん")")
                    HStack{
                        Button("プロフィール編集はこちら"){
                            wholeappafterloginmodel.GoToProfileChangeView = true
                        }
                        Button("ログアウト"){
                            LogoutButtonClicked = true
                        }
                    }
                }.alert(isPresented: $LogoutButtonClicked){
                    Alert(title: Text("本当にログアウトしますか？"),
                          primaryButton: .default(Text("ログアウト"), action: {
                        wholeappafterloginmodel.GoToLogout = true
                    }),
                          secondaryButton: .cancel(Text("キャンセル"),action:{
                        wholeappafterloginmodel.GoToLogout = false
                    })
                    )
                }
                
            }
            else{
                Text("Error")
            }
        }.onAppear{
            wholeappafterloginmodel.GoToProfileChangeView = false
        }
    }
}
