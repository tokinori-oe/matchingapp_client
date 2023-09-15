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
                .environmentObject(AfterLoginModel()) //これは後で削除
                .environmentObject(AccountCheckModel())//これも後で削除
                .environmentObject(WholeAppAfterLoginModel())
        }
    }
}

