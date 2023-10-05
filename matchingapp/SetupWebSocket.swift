//
//  SetupWebSocket.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/14.
//

import SwiftUI
import Starscream

//WebSocket接続を管理するクライアントクラスを作成


//WebSocketDelegateプロトコルは、WebSocket接続に関連するイベントやデータを受け取るためのメソッドを定義
//WebSocketサーバーとの接続状態が変化したときに、WebSocketManagerがそれを検知し、対応するアクションを実行する
//WebSocketManagerがテキストメッセージを受信したときに、そのメッセージを受信プロパティである receivedMessage に代入します。これにより、アプリ内でWebSocketから受信したメッセージを処理および表示できるよ
//上記以外のWebSocketイベントに対しては、何も行わずに default ブロックで終了
//ObservedObjectで受け継いていく

class WebSocketManager: ObservableObject, WebSocketDelegate {
    
    private var socket: WebSocket?
    @Published var receivedMessage: String = ""
    @Published var receiver: Int = 0
    @Published var isConnected = false
    @Published var disConnected = true
    //@Published var ListOfCandidate :[UserProfileData] = []
    @Published var ListOfRequest :[DataOfRequest] = []
    @Published var ListOfMessage :[DataOfChat] = []
    
    //init() {
        //setupWebSocket()
    //}

    func setupWebSocket() {
        if let url = URL(string: "ws://127.0.0.1:8000/request_path/\(receiver)/") {
            socket = WebSocket(request: URLRequest(url: url))
            socket?.delegate = self // WebSocketManagerをWebSocketDelegateに設定
            //StarscreamではWebsocketクラスが準備されており、WebSocket インスタンスの connect() メソッドを呼び出し、WebSocketサーバーへの実際の接続を試みる。接続が確立されると、WebSocketManagerの didReceive(event: WebSocketEvent, client: WebSocketClient) メソッドが呼び出され、接続状態が変化したことを検出することができる。
            socket?.connect()
        }
    }
    
    func disconnectWebSocket(){
        socket?.disconnect()
    }
    
    func sendRequest(sender: Int, receiver: Int) {
        let requestData: [String: Int] = [
            "sender" : sender,
            "receiver" : receiver
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestData),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            socket?.write(string: jsonString)
        }
    }

    // WebSocketDelegateの要件を実装
    func didReceive(event: WebSocketEvent, client: WebSocketClient){
        switch event {
        case .connected:
            isConnected = true
            disConnected = false
            print("Connected")
        case .disconnected:
            isConnected = false
            disConnected = true
            print(disConnected)
        case .text(let jsonString):
            if let data = jsonString.data(using: .utf8){
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let dictionary = dictionary {
                        if let content = dictionary["content"] as? String{
                            if content == "Request"{
                                //オブジェクトを作成(これはリクエスト一覧で表示するためのオブジェクト)
                                let request = DataOfRequest(
                                    content: dictionary["content"] as? String,
                                    school_name : dictionary["school_name"] as? String,
                                    faculty: dictionary["faculty"] as? String,
                                    department: dictionary["department"] as? String,
                                    grade: dictionary["grade"] as? String,
                                    hobbies: dictionary["hobbies"] as? String,
                                    age: dictionary["age"] as? Int,
                                    profile: dictionary["profile"] as? String,
                                    date : dictionary["date"] as? Date
                                )
                            }
                            else if content == "Mail"{
                                
                            }
                            else{
                                
                            }
                        }
                    }

                }catch{
                    print("JSONデコードエラー: \(error)")
                }
            }
        default:
            break
        }
    }
}
