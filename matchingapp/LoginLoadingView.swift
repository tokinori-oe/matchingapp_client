import SwiftUI
import Starscream

//この画面でuser_id, プロフィール情報、websocket接続を行う。全て完了したらHomePageViewに飛ぶ
struct LoginLoadingView: View {
    @EnvironmentObject var wholeappafterloginmodel : WholeAppAfterLoginModel
    @State private var getInfoAboutAccount = false
    @ObservedObject private var webSocketManager = WebSocketManager()
    @State private var GoToHomePage = false
    
    var body: some View {
        NavigationStack{
            VStack {
                LottieView(name:"whiteblue_loading")
                    .frame(width: 100.0, height: 100.0)
                Text("Now loading...")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .frame(width: nil)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .onAppear{
                getUserID()
                getWebSocketConnection()
                GoToHomePage = getInfoAboutAccount && webSocketManager.isConnected
            }
            .navigationDestination(isPresented: $GoToHomePage){
                HomepageView()
            }
        }
    }
    
    func getUserID(){
        guard let url = URL(string:"http://127.0.0.1:8000/api/account_check/")else{
            return
        }
        
        if let token = UserDefaults.standard.string(forKey: "AuthToken"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
            
            //HTTPリクエストを送信
            URLSession.shared.dataTask(with:request){data, response, error in
                if let data = data{
                    
                    do {
                        // JSONデコードを試行
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let userId = jsonObject["user_id"] as? Int {
                            DispatchQueue.main.async {
                                print("user_id: \(userId)")
                                wholeappafterloginmodel.userID = userId // userIDを更新
                                webSocketManager.receiver = userId
                                getUserProfile()
                            }
                        }
                    } catch {
                        print("JSONデコードエラー: \(error)")
                                           
                    }
                }
            }.resume()
        }else{
            return
        }
    }
    
    func getUserProfile(){
        
        let account_id = wholeappafterloginmodel.userID ?? 0
        guard let getinfo_url = URL(string: "http://127.0.0.1:8000/api/get_accountinfo/?user_id=\(account_id)") else {
            return
        }

        if let id = wholeappafterloginmodel.userID{
            var request = URLRequest(url: getinfo_url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request){data, response, error in
                if let error = error {
                        print("HTTPリクエストエラー: \(error)")
                        return
                    }
                if let data = data{
                    do {
                        // JSONデコードを試行
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            DispatchQueue.main.async {
                                if let error = jsonObject["error"]{
                                    getInfoAboutAccount = false
                                    print(error)
                                }
                                else{
                                    wholeappafterloginmodel.school_name = jsonObject["school_name"] as? String
                                    wholeappafterloginmodel.faculty = jsonObject["faculty"] as? String
                                    wholeappafterloginmodel.department = jsonObject["department"] as? String
                                    wholeappafterloginmodel.hobbies = jsonObject["hobbies"] as? String
                                    wholeappafterloginmodel.profile = jsonObject["profile"] as? String
                                    wholeappafterloginmodel.age = jsonObject["age"] as? Int
                                    wholeappafterloginmodel.gender = jsonObject["gender"] as? String
                                    wholeappafterloginmodel.grade = jsonObject["grade"] as? String
                                    getInfoAboutAccount=true
                                }
                            }
                        }
                    } catch {
                        print("JSONデコードエラー: \(error)")
                    }
                }
            }.resume()
        }else{
            return
        }
        

    }
    
    func getWebSocketConnection(){
        webSocketManager.setupWebSocket() //接続？
    }
    
}

