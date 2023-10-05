//
//  matchingappApp.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/08/28.
//

import SwiftUI

@main
struct matchingappApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(WholeAppAfterLoginModel())
                .environmentObject(WebSocketManager())
                
        }
    }
}

