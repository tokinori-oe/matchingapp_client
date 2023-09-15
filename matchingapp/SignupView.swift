
import SwiftUI


struct SignupView: View {
    @ObservedObject var authViewModel = AuthViewModel()
    @State var message = ""
    @State var Success = false
    var body: some View {
        NavigationStack{
        VStack{
            Text(message)
                .foregroundColor(Color.red)
            Text("アカウント作成")
                .padding(.bottom, 24.0)
                .font(.system(size: 25))
            Text("メールアドレス")
                .multilineTextAlignment(.center)
                .padding(.trailing, 126.0)
            TextField("email", text: $authViewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .frame(width: 250)
            Text("ユーザー名")
                .multilineTextAlignment(.center)
                .padding(.trailing, 162.0)
            TextField("username", text: $authViewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .frame(width: 250)
            Text("パスワード")
                .multilineTextAlignment(.center)
                .padding(.trailing, 162.0)
            TextField("password", text: $authViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .frame(width: 250)
            Button("次へ", action:send_email)
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.borderedProminent)
                
            }
        .navigationDestination(isPresented: $Success){
            SelectGenderView(authViewModel: authViewModel) //これの意味は？
        }
        .navigationDestination(isPresented: $authViewModel.signback){
                    LoginView()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button(action:{
                    authViewModel.email = ""
                    authViewModel.username = ""
                    authViewModel.password = ""
                    authViewModel.signback = true
                }){
                    HStack{
                        Image(systemName: "chevron.left") 
                        Text("戻る")
                    }
                }
            }
        }
        }
            .padding()
    }
    func send_email(){
        guard let url = URL(string: "http://127.0.0.1:8000/api/check_user/")else{
            return
        }
        
        let account_info:[String:Any]=[
            "username":authViewModel.username,
            "email":authViewModel.email,
            "password":authViewModel.password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: account_info)
        
        //HTTPリクエストを送信
        URLSession.shared.dataTask(with: request) { data, response, error in
            // data, response, error はここで使用可能
            if let data = data {
                // レスポンスの処理
                if let responseString = String(data: data, encoding: .utf8){
                    if responseString.contains("不可能なユーザーです"){
                        message = "既に存在するユーザーです"
                        authViewModel.username=""
                        authViewModel.email=""
                        authViewModel.password=""
                    }
                    else{
                        print("Response: \(responseString)")
                        Success = true
                    }
                }
            }
        }.resume()
    }
}



struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
