//
//  LoginView.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import ComposableArchitecture
import SwiftUI

struct LoginTextInputView: View {
    let title: String
    let binding: Binding<String>

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
            TextField(title, text: binding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct LoginView: View {
    let store: Store<LoginState, LoginAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .center, spacing: 32) {
                LoginTextInputView(
                    title: "メールアドレス",
                    binding: viewStore.binding(
                        get: \.emailAddress,
                        send: LoginAction.didEmailAddressChange
                    )
                )
                LoginTextInputView(
                    title: "パスワード",
                    binding: viewStore.binding(
                        get: \.password,
                        send: LoginAction.didPasswordChange
                    )
                )
                Button {
                    print("hoge") // FIXME:
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
                .disabled(!viewStore.isValidEmailAddress)
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
                loginPasswordValidator: LoginPasswordValidator()
            )
        ))
    }
}

// MARK: - Private extensions

private extension LoginState {
    var buttonColor: Color {
        if isValidEmailAddress {
            return .primary
        } else {
            return .secondary
        }
    }
}
