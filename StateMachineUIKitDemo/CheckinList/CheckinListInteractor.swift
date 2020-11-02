//
//  CheckinListInteractor.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 08.09.2020.
//

import Foundation
import Combine

protocol CheckinListInteractor {
    var stateMachine: CheckinListStateMachine { get }

    func logout()
    func refresh()
}

class CheckinListInteractorImpl: CheckinListInteractor {
    private(set) var stateMachine = CheckinListStateMachine()
    private var logoutSubscription: AnyCancellable?
    private var checkinsSubscription: AnyCancellable?

    private let authManager: AuthManager
    private let checkinDataService: CheckinDataService

    init(authManager: AuthManager, checkinStorage: CheckinDataService) {
        self.authManager = authManager
        self.checkinDataService = checkinStorage
    }
    
    func refresh() {
        stateMachine.transition(with: .startLoading)
        checkinsSubscription = checkinDataService
            .fetchCheckins()
            .map { checkins in
                CheckinListStateMachine.Event.loadingFinished(checkins)
            }
            .catch { error in
                Just(CheckinListStateMachine.Event.loadingFailed(error))
            }
            .sink { [stateMachine] event in
                stateMachine.transition(with: event)
            }
    }

    func logout() {
        logoutSubscription = authManager.logout()
            .sink { [stateMachine] in
                stateMachine.transition(with: .logout)
            }
    }
}
