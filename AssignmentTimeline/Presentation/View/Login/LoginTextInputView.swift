//
//  LoginTextInputView.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

import SwiftUI

struct LoginTextInputView: View {
    let title: String
    let shouldMaskText: Bool
    let binding: Binding<String>

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
            Group {
                if shouldMaskText {
                    SecureField(title, text: binding)
                } else {
                    TextField(title, text: binding)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.alphabet)
        }
    }
}
