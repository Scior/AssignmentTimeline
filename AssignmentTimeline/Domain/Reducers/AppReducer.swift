//
//  AppReducer.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import ComposableArchitecture

extension SharedReducers {
    static let app = Reducer<AppState, AppAction, AppEnvironment>.combine(
        SharedReducers.login.pullback(
            state: /AppState.login,
            action: /AppAction.login,
            environment: { environment in
                return LoginEnvironment(
                    emailAddressValidator: EmailAddressValidator(),
                    loginPasswordValidator: LoginPasswordValidator(),
                    loginRepository: LoginRepository(dependency: .init(
                        client: environment.apiClient
                    )),
                    accessTokenRepository: AccessTokenRepository(),
                    mainQueue: environment.mainQueue
                )
            }
        ),
        SharedReducers.timeline.pullback(
            state: /AppState.timeline,
            action: /AppAction.timeline,
            environment: { environment in
                return TimelineEnvironment(
                    repository: TimelineRepository(dependency: .init(client: environment.apiClient)),
                    mainQueue: environment.mainQueue
                )
            }
        ),
        Reducer { state, action, _ in
            switch action {
            case .login(.loginResponse(.success)):
                state = .timeline(.empty)
                return .none
            default:
                return .none
            }
        }
    )
}
