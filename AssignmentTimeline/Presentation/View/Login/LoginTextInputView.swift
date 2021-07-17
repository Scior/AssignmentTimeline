//
//  LoginTextInputView.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/17.
//

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
