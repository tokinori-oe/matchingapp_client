//
//  EachRecommendationView.swift
//  matchingapp
//
//  Created by Tokinori Oe on 2023/09/11.
//

import SwiftUI

struct EachRecommendationView: View {
    var profile: UserProfileData
    @EnvironmentObject var requestmodel : RequestModel
    
    var body: some View {
        VStack{
            Text("年齢:　\(profile.age.map(String.init) ?? "未公開")")
            Text("学校名: \(profile.school_name)")
            Text("プロフィール: \(profile.profile ?? "")")
            Button("リクエスト"){
                requestmodel.isButtonClicked = true
            }
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.borderedProminent)
            
            
        }.cornerRadius(8)
    }
}
