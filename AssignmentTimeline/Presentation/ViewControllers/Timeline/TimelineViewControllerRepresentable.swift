//
//  TimelineViewControllerRepresentable.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import class ComposableArchitecture.Store
import SwiftUI

struct TimelineViewControllerRepresentable: UIViewControllerRepresentable {
    private let store: Store<TimelineState, TimelineAction>

    init(store: Store<TimelineState, TimelineAction>) {
        self.store = store
    }

    func makeUIViewController(context: Context) -> TimelineViewController {
        return .init(store: store)
    }

    func updateUIViewController(_ uiViewController: TimelineViewController, context: Context) {}
}
