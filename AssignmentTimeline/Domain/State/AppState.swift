//
//  AppState.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

enum AppState: Equatable {
    case login(LoginState)
    case timeline(TimelineState)
}
