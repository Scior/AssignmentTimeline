//
//  LoginAlertView.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

import ComposableArchitecture
import SwiftUI

struct LoginAlertView: View {
    let store: Store<LoginAlertState, LoginAlertAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            Text(viewStore.state.errorType?.message ?? "")
                .font(.caption)
                .foregroundColor(.red)
                .opacity(viewStore.state.errorType.map { _ in 1 } ?? 0)
        }
    }
}

struct LoginAlertView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAlertView(store: .init(
            initialState: .init(errorType: .incorrectInputs),
            reducer: SharedReducers.loginAlert,
            environment: EmptyEnvironment()
        ))
    }
}

// MARK: - Private extensions

private extension LoginAlertState.ErrorType {
    var message: String {
        switch self {
        case .incorrectInputs:
            return "メールアドレスまたはパスワードが異なります" // 詳しくは書いてはいけない
        case .others:
            return "サーバーエラーです。時間を置いてから再度お試しください"
        }
    }
}
