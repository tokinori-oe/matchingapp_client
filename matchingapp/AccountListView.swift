//
//  AccountListView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/07.
//

import SwiftUI

struct AccountListView: View {
    @EnvironmentObject var wholeappafterloginmodel : WholeAppAfterLoginModel
    @State private var isAccessedToAccountCheck = false
    @State private var getInfoAboutAccount = false
    var body: some View {
        NavigationStack{
            if isAccessedToAccountCheck, getInfoAboutAccount{
                //後々Tableという機能を使って表を書くからプロフィールの情報はオブジェクト配列を使った方が良さそう
                let school = wholeappafterloginmodel.school_name
                VStack{
                    Text("school_name: \(wholeappafterloginmodel.school_name ?? "エラー起きてるよん")")
                    Button("プロフィール編集はこちら"){
                        wholeappafterloginmodel.GoToProfileChangeView = true
                    }
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

struct AccountListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListView()
    }
}
