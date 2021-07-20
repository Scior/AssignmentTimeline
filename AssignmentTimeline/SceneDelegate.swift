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
        self.window?.rootViewController = UIHostingController(
            rootView: RootView(store: .init(
                initialState: .login(.empty),
                reducer: SharedReducers.app,
                environment: AppEnvironment(
                    apiClient: APIClient.shared,
                    accessTokenRepository: AccessTokenRepository(),
                    mainQueue: .main
                )
            ))
        )
        self.window?.makeKeyAndVisible()
    }
}
