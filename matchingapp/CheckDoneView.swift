//
//  CheckDoneView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/04.
//

import SwiftUI

struct CheckDoneView: View {
    @State private var gotoLogin = false
    @EnvironmentObject var authViewModel : AuthViewModel
    var body: some View {
        NavigationStack{
            VStack{
                Text("アカウント登録が完了しました！")
                    .font(.system(size: 25))
                    .padding(.bottom, 24.0)
                Button("ログイン画面に戻る"){
                    gotoLogin = true
                    authViewModel.username = ""
                    authViewModel.password = ""
                    authViewModel.email = ""
                    authViewModel.School =  ""
                    authViewModel.faculty = ""
                    authViewModel.department = ""
                    authViewModel.age = ""
                    authViewModel.grade = ""
                    authViewModel.hobbies = ""
                    authViewModel.profile = ""
                    authViewModel.gender = ""
                    
                }
            }.navigationDestination(isPresented: $gotoLogin){
                LoginView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CheckDoneView_Previews: PreviewProvider {
    static var previews: some View {
        CheckDoneView()
    }
}
