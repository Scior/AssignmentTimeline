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
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
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
            environment: LoginEnvironment()
        ))
    }
}
