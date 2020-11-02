//
//  CheckinListStateMachine.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 08.09.2020.
//

import Foundation

protocol CheckinListStateMachineObserver: AnyObject {
    func checkinListStateMachine(_ stateMachine: CheckinListStateMachine,
                                 didEnter state: CheckinListStateMachine.State)
}

class CheckinListStateMachine {
    enum State: Equatable {
        case idle
        case loggedOut
        case loading
        case error(CheckinDataSourceError)
        case empty
        case list([Checkin])
    }

    enum Event {
        case startLoading
        case loadingFailed(CheckinDataSourceError)
        case loadingFinished([Checkin])
        case logout
    }

    weak var observer: CheckinListStateMachineObserver?

    private(set) var state: State = .idle {
        didSet {
            guard oldValue != state else { return }
            observer?.checkinListStateMachine(self, didEnter: state)
        }
    }

    func transition(with event: Event) {
        switch (state, event) {
        case (.idle, .startLoading):
            state = .loading
        case (.idle, _):
            break

        case let (.loading, .loadingFailed(error)) where error == .noAuth:
            state = .loggedOut
        case (.loading, .loadingFailed):
            state = .error(.failedToLoadData)
        case let (.loading, .loadingFinished(items)) where items.isEmpty:
            state = .empty
        case let (.loading, .loadingFinished(items)):
            state = .list(items)
        case (.loading, _):
            break

        case (.loggedOut, .startLoading):
            state = .loading
        case (.loggedOut, _):
            break

        case (.error, .startLoading):
            state = .loading
        case (.error, .logout):
            state = .loggedOut
        case (.error, _):
            break

        case (.empty, .startLoading):
            state = .loading
        case (.empty, .logout):
            state = .loggedOut
        case (.empty, _):
            break

        case (.list, .startLoading):
            state = .loading
        case (.list, .logout):
            state = .loggedOut
        case (.list, _):
            break
        }
    }
}
