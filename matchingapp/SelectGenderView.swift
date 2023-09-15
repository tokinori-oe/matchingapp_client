//
//  SelectGenderView().swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/04.
//

import SwiftUI

struct SelectGenderView: View {
    @State var isChecked = false
    @ObservedObject var authViewModel : AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("性別を選択してください")
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 24.0)
                    .font(.system(size: 25))
                    .foregroundColor(Color.black)
                HStack{
                    Button(action: {
                        authViewModel.gender = "男"
                        isChecked = true
                    }){
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue)
                            .frame(width: 200, height:200)
                            .overlay(Text("男").font(.title2))
                            .foregroundColor(.white)
                    }
                    Button(action: {
                        authViewModel.gender = "女"
                        isChecked = true
                    }){
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue)
                            .frame(width: 200, height:200)
                            .overlay(Text("女").font(.title2))
                            .foregroundColor(.white)
                    }
                }
            }.navigationDestination(isPresented: $isChecked){
                SelectYourSchool(authViewModel: authViewModel)
            }
            .navigationDestination(isPresented:$authViewModel.genderback){
                SignupView(authViewModel : authViewModel)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action:{
                        authViewModel.gender = ""
                        authViewModel.genderback = true
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
}

struct GenderBackButton: View {
    
    @ObservedObject var authViewModel = AuthViewModel()
    var label: String
    var body: some View {
            Button(action: {
                authViewModel.gender = ""
                SignupView()
                    }) {
                    HStack {
                Image(systemName: "chevron.left") // 戻るアイコン
                Text(label)
            }
        }
    }
}
