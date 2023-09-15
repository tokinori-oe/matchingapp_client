//
//  LottieView.swift
//  IPPON_ONLINE_FRONT
//
//  Created by Tokinori Oe on 2023/08/11.
//

import Foundation
import SwiftUI
import Lottie

//LottieviewがUIReperesentableプロトコルに準拠することを指定
struct LottieView: UIViewRepresentable {
    var name: String
    //LottieAnimationViewというクラスのインスタンスを作成
    //LottieAnimationView は、Lottieライブラリで提供されるクラスで、Lottieアニメーションを表示するためのコンポーネント
    var animationView = LottieAnimationView()
    
    //UIRepresentableプロトコルを使用するためにはLottieをimportする必要がある
    //UIRepresentableプロトコルに準拠すると必ずmakeUIViewメソッドを作る必要がある
    //makeUIViewのコンテキスト情報はUIViewRepresentableContextで、ジェネリック（UIViewRepresentableContextをLottieviewに対してパラメータ化する）はLottieViewでなければならない
    //このメソッド内で、UIKitの UIView インスタンスを生成し、そのビューを設定するコードを記述する
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        //UIViewのインスタンスを作成
        let view = UIView(frame: .zero)
        // 表示したいアニメーションのファイル名
        animationView.animation = LottieAnimation.named(name)
        // 比率
        animationView.contentMode = .scaleAspectFit
        // ループモード
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    //UIRepresentableプロトコルにupdateUIViewは必須
    //updateUIViewはViewが更新される時の操作を表す
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
}
