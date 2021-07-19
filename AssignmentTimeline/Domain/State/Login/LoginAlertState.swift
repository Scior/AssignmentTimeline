//
//  LoginAlertState.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/18.
//

struct LoginAlertState: Equatable {
    enum ErrorType {
        case incorrectInputs
        case others
    }

    var errorType: ErrorType?
}
