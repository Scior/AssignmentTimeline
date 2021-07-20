//
//  TimelineViewControllerRepresentable.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import SwiftUI

struct TimelineViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TimelineViewController {
        return .init(store: .init(
            initialState: .empty,
            reducer: SharedReducers.timeline,
            environment: TimelineEnvironment(
                repository: TimelineRepository(dependency: .init(client: APIClient.shared)),
                mainQueue: .main
            )
        ))
    }

    func updateUIViewController(_ uiViewController: TimelineViewController, context: Context) {}
}
