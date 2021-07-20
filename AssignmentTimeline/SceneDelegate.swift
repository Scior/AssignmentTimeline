//
//  SceneDelegate.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/16.
//

import ComposableArchitecture
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.window = (scene as? UIWindowScene).map(UIWindow.init(windowScene:))

        // access tokenがkeychainにあれば、timelineを表示
        // AccessTokenRepository.shared.clear()
        // ここで上を実行すればkeychainの値を削除できる
        let appState: AppState
        if AccessTokenRepository.shared.get() == nil {
            appState = .login(.empty)
        } else {
            appState = .timeline(.empty)
        }

        self.window?.rootViewController = UIHostingController(
            rootView: RootView(store: .init(
                initialState: appState,
                reducer: SharedReducers.app,
                environment: AppEnvironment(
                    apiClient: APIClient.shared,
                    accessTokenRepository: AccessTokenRepository.shared,
                    mainQueue: .main
                )
            ))
        )
        self.window?.makeKeyAndVisible()
    }
}
