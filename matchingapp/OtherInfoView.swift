//
//  OtherInfoView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/04.
//

import SwiftUI

struct OtherInfoView: View {
    @ObservedObject var authViewModel : AuthViewModel
    @State private var message = ""
    @State private var isRegistered = false
    var body: some View {
        NavigationStack{
            VStack{
                Text(message)
                    .foregroundColor(Color.red)
                Text("その他情報")
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 24.0)
                    .font(.system(size: 25))
                    .foregroundColor(Color.black)
                Text("年齢(任意)")
                
                TextField("年齢", text: $authViewModel.age)
                Text("趣味(任意)")
                TextField("趣味", text: $authViewModel.hobbies)
                    .frame(height: 200.0)
                Text("プロフィール(任意)")
                TextField("プロフィール", text: $authViewModel.profile)
                    .frame(height: 300.0)
                Button("確認画面へ"){
                    isRegistered = true
                }
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.borderedProminent)
                
            }.navigationDestination(isPresented: $isRegistered){
                CheckWholeInfoView(authViewModel:authViewModel)
                }
            .navigationDestination(isPresented: $authViewModel.otherback){
                SelectFacultyAndDepartment(authViewModel: authViewModel)
                }
                    .navigationBarBackButtonHidden(true)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Button(action:{
                                authViewModel.age = ""
                                authViewModel.hobbies = ""
                                authViewModel.profile = ""
                                authViewModel.otherback = true
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
