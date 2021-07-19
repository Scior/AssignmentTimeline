//
//  LoginView.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    let store: Store<LoginState, LoginAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .center, spacing: 32) {
                LoginTextInputView(
                    title: "メールアドレス",
                    shouldMaskText: false,
                    binding: viewStore.binding(
                        get: \.emailAddress,
                        send: LoginAction.emailAddressChanged
                    )
                )
                LoginTextInputView(
                    title: "パスワード",
                    shouldMaskText: true,
                    binding: viewStore.binding(
                        get: \.password,
                        send: LoginAction.passwordChanged
                    )
                )
                VStack(alignment: .center, spacing: 16) {
                    LoginAlertView(store: .init(
                        initialState: .init(),
                        reducer: SharedReducers.loginAlert,
                        environment: EmptyEnvironment()
                    ))
                    Button {
                        viewStore.send(.loginButtonTapped)
                    } label: {
                        Text("ログイン")
                            .font(.body)
                            .bold()
                            .foregroundColor(viewStore.buttonColor)
                            .padding(.horizontal, 48)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(viewStore.buttonColor, lineWidth: 2)
                            )
                    }
                    .disabled(!viewStore.hasValidInputs)
                }
            }.padding(.horizontal, 24)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: .init(
            initialState: .empty,
            reducer: SharedReducers.login,
            environment: LoginEnvironment(
                emailAddressValidator: EmailAddressValidator(),
                loginPasswordValidator: LoginPasswordValidator(),
                repository: LoginRepository(dependency: .init(
                    client: APIClient.shared
                )),
                mainQueue: .main
            )
        ))
    }
}

// MARK: - Private extensions

private extension LoginState {
    var hasValidInputs: Bool {
        return isValidPassword && isValidEmailAddress
    }

    var buttonColor: Color {
        if hasValidInputs {
            return .primary
        } else {
            return .secondary
        }
    }
}
