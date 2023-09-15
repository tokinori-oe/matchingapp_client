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
    
    init() {
        setupWebSocket()
    }

    func setupWebSocket() {
        if let url = URL(string: "ws://localhost:8000/request_path/\(receiver)/") {
            socket = WebSocket(request: URLRequest(url: url))
            socket?.delegate = self // WebSocketManagerをWebSocketDelegateに設定
            socket?.connect()
        }
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
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient){
        switch event {
        case .connected:
            print("WebSocket Connected")
        case .disconnected(_, _): //切断の原因や詳細情報は、パラメータとして提供されますが、コード内でそれらの情報を使用しない場合、_（アンダースコア）を使用して無視することができる
            print("WebSocket Disconnected")
        case .text(let string): //WebSocketManagerがテキストメッセージを受信したときに、そのメッセージを受信プロパティである receivedMessage に代入
            receivedMessage = string
        default:
            break
        }
    }
}
