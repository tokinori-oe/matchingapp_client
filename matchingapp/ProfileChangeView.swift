//
//  ProfileChangeView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/10.
//

import SwiftUI

struct ProfileChangeView: View {
    @EnvironmentObject var wholeappafterloginmodel : WholeAppAfterLoginModel
    @State var isDoneChanged = false
    @State var BackToAccountCheck = false
    @EnvironmentObject var websocketmanager : WebSocketManager
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    Text("プロフィール情報変更")
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 24.0)
                        .font(.system(size: 25))
                        .foregroundColor(Color.black)
                    Text("学校名")
                    TextField("学校名", text: Binding(
                        get: { wholeappafterloginmodel.school_name ?? "" },
                        set: { wholeappafterloginmodel.school_name = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                    Text("学部")
                    TextField("学部", text: Binding(
                        get: { wholeappafterloginmodel.faculty ?? "" },
                        set: { wholeappafterloginmodel.faculty = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                    Text("学科")
                    TextField("学部", text: Binding(
                        get: { wholeappafterloginmodel.department ?? "" },
                        set: { wholeappafterloginmodel.department = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                    Text("学年")
                    TextField("学年", text: Binding(
                        get: { wholeappafterloginmodel.grade ?? "" },
                        set: { wholeappafterloginmodel.grade = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                }
                VStack{
                    Text("趣味")
                    TextField("趣味", text: Binding(
                        get: { wholeappafterloginmodel.hobbies ?? "" },
                        set: { wholeappafterloginmodel.hobbies = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                    
                    Text("年齢")
                    TextField("年齢", value: Binding(
                        get: { wholeappafterloginmodel.age ?? 0 },
                        set: { wholeappafterloginmodel.age = $0 }
                    ), formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                    
                    Text("性別")
                    TextField("性別", text: Binding(
                        get: { wholeappafterloginmodel.grade ?? "" },
                        set: { wholeappafterloginmodel.grade = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                    
                    Text("プロフィール")
                    TextField("性別", text: Binding(
                        get: { wholeappafterloginmodel.gender ?? "" },
                        set: { wholeappafterloginmodel.gender = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 250)
                    Button("変更する", action: changeprofile)
                }
            }.navigationDestination(isPresented: $isDoneChanged){
                HomepageView()
            }
            .navigationDestination(isPresented: $BackToAccountCheck){
                HomepageView()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action:{
                        wholeappafterloginmodel.selectedTag = 1
                        BackToAccountCheck = true
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
    
    func changeprofile(){
        
        let account_id = wholeappafterloginmodel.userID ?? 0
        guard let change_url = URL(string: "http://127.0.0.1:8000/api/change_accountinfo/?user_id=\(account_id)")else{
            return
        }
        //print(accountcheckmodel.school_name)
        let ChangeDetails : [String:Any] = [
            "user" : wholeappafterloginmodel.userID ?? 0,
            "school_name" : wholeappafterloginmodel.school_name ?? "",
            "faculty" : wholeappafterloginmodel.faculty ?? "",
            "department" : wholeappafterloginmodel.department ?? "",
            "grade" : wholeappafterloginmodel.grade ?? "",
            "hobbies" : wholeappafterloginmodel.hobbies ?? "",
            "age" : wholeappafterloginmodel.age,
            "gender" : wholeappafterloginmodel.gender ?? "",
            "profile" : wholeappafterloginmodel.profile ?? ""
        ]
        
        var request = URLRequest(url: change_url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ChangeDetails)
        } catch {
            print("Error encoding user data: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                    print("HTTPリクエストエラー: \(error)")
                    return
                }
            if let data = data{
                if let responseString = String(data: data, encoding: .utf8){
                    if responseString.contains("UserProfile not found"){
                        isDoneChanged = false
                    }
                    else{
                        wholeappafterloginmodel.selectedTag = 1
                        isDoneChanged = true
                    }

                }
            }
        }.resume()
        
    }
}
