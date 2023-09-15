//
//  SelectYourSchool.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/02.
//

import SwiftUI

struct SelectYourSchool: View {
    
    @State var  school_options:[String] = []
    @State var message = ""
    // ユーザーが選択した選択肢
    @State var isRegistered = false
    @ObservedObject var authViewModel: AuthViewModel
    
    // 検索バーのテキスト
    @State private var searchText = ""
    var body: some View {
        NavigationStack{
            VStack{
                Text(message)
                    .foregroundColor(Color.red)
                List {
                    ForEach(searchResults, id:\.self){ name in
                        Button(name){
                            authViewModel.School = name
                            isRegistered = true
                            
                        }
                    }
                }
                    .searchable(text: $searchText)
                    .keyboardType(.default)
                    .navigationTitle("通っている大学を選択してください")
                    .navigationBarTitleDisplayMode(.inline)
                }.scrollDismissesKeyboard(.immediately)
                .navigationDestination(isPresented: $isRegistered){
                    SelectFacultyAndDepartment(authViewModel:authViewModel)
                }
                .navigationDestination(isPresented: $authViewModel.schoolback){
                    SelectGenderView(authViewModel:authViewModel)
                }
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action:{
                            authViewModel.School = ""
                            authViewModel.schoolback = true
                        }){
                            HStack{
                                Image(systemName: "chevron.left")
                                Text("戻る")
                            }
                        }
                    }
                }
                
            }
            .onAppear{
                fetchData()
            }
        }
    
    var searchResults: [String]{
        if !searchText.isEmpty{
            return school_options.filter{$0.contains(searchText)}
        }
        else{
            return school_options.filter{$0.contains(searchText)}
        }
    }
    
    func fetchData(){
        guard let url = URL(string:"http://127.0.0.1:8000/api/school/")else{
            return
        }
        
        //URLSessionのdatataskを使いdataとresponseとerrorを取得
        URLSession.shared.dataTask(with: url){(data, responst, error) in
            if let data = data{
                //データをパースしてデータモデルに格納
                if let DecodedData = try? JSONDecoder().decode([String: [String]].self, from:data){
                    DispatchQueue.main.async {
                        //データをビューモデルに設定
                        if let schoolOptions = DecodedData["schoolOptions"]{
                            school_options = schoolOptions
                        }
                    }
                }
            }
        }.resume()
    }
}
