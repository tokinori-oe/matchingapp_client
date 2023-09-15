//
//  SelectFacultyAndDepartment.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/03.
//

import SwiftUI

struct SelectFacultyAndDepartment: View {
    @State private var message = ""
    @ObservedObject var authViewModel : AuthViewModel
    @State var isTyped = false
    var body: some View {
        NavigationStack{
            VStack{
                Text(message)
                    .foregroundColor(Color.red)
                Text("学年、学部、学科を入力してください")
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 24.0)
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
                Text("学年")
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 210.0)
                TextField("学年を入力してください", text: $authViewModel.grade)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                Text("学部")
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 210.0)
                TextField("学部を入力してください", text: $authViewModel.faculty)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                Text("学科")
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 210.0)
                TextField("学科を入力してください", text:$authViewModel.department)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                Button("次へ", action:checkcontent)
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
                    
            }.navigationDestination(isPresented: $isTyped){
                OtherInfoView(authViewModel:authViewModel)
            }
            .navigationDestination(isPresented: $authViewModel.facultyback){
                SelectYourSchool(authViewModel:authViewModel)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action:{
                        authViewModel.grade = ""
                        authViewModel.faculty = ""
                        authViewModel.department = ""
                        authViewModel.facultyback = true
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
    func checkcontent(){
        if !authViewModel.faculty.isEmpty && !authViewModel.department.isEmpty &&
            !authViewModel.grade.isEmpty{
            isTyped = true
        }
        else{
            message = "学年、学部または学科を正しく入力してください"
        }
        
    }
}
