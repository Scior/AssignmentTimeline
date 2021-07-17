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
            rootView: LoginView(store: .init(
                initialState: .empty,
                reducer: SharedReducers.login,
                environment: LoginEnvironment()
            ))
        )
        self.window?.makeKeyAndVisible()
    }
}
