//
//  RootView.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        SwitchStore(self.store) {
            CaseLet(state: /AppState.login, action: AppAction.login) { store in
                LoginView(store: store)
            }
            CaseLet(state: /AppState.timeline, action: AppAction.timeline) { _ in
                TimelineViewControllerRepresentable() // FIXME: inject store
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: .init(
            initialState: .login(.empty),
            reducer: SharedReducers.app,
            environment: AppEnvironment(
                apiClient: APIClient.shared,
                accessTokenRepository: AccessTokenRepository(),
                mainQueue: .main
            )
        ))
    }
}
