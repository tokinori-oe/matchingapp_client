import SwiftUI
import Starscream

//この画面でuser_id, プロフィール情報、websocket接続を行う。全て完了したらHomePageViewに飛ぶ
struct LogoutLoadingView: View {
    @EnvironmentObject var wholeappafterloginmodel : WholeAppAfterLoginModel
    @EnvironmentObject var websocketmanager : WebSocketManager
    
    var body: some View {
        NavigationStack{
            VStack {
                LottieView(name:"whiteblue_loading")
                    .frame(width: 100.0, height: 100.0)
            }
            .padding()
            //iris.navigationBarBackButtonHidden(true)
            .onAppear{
                websocketmanager.disconnectWebSocket()
                //要訂正
                websocketmanager.disConnected = true
                websocketmanager.isConnected = false
            }
            .navigationDestination(isPresented: $websocketmanager.disConnected){
                LoginView()
            }
        }
    }
    
}

