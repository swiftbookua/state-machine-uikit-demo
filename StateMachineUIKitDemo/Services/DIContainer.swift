//
//  DIContainer.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 18.09.2020.
//

import Foundation

class DIContainer {
    static let shared = DIContainer()

    lazy var authManager = AuthManager()
    lazy var checkinStorage: CheckinDataService = MockCheckinDataService(authManager: authManager)

    func makeCheckinListInteractor() -> CheckinListInteractor {
        return CheckinListInteractorImpl(authManager: authManager, checkinStorage: checkinStorage)
    }
}
