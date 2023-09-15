import SwiftUI
import Starscream

//この画面でuser_id, プロフィール情報、websocket接続を行う。全て完了したらHomePageViewに飛ぶ
struct LoginLoadingView: View {
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
                
            }
        }
    }
    
    func getUserID(){
        
    }
    
    func getUserProfile(){
        
    }
    
    func getWebSocketConnection(){
        
    }
    
}

