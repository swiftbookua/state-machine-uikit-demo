//
//  AuthManager.swift
//  StateMachinesSwiftUI
//
//  Created by Viacheslav Volodko on 18.08.2020.
//

import Foundation
import Combine

struct User: Hashable, Equatable {
    var username: String
}

enum AuthManagerError: Error, LocalizedError {
    case invalidCredentials
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid credentials"
        }
    }
}

class AuthManager: ObservableObject {
    @Published private(set) var currentUser: User? = nil
    func login(username: String, password: String) -> Future<User, AuthManagerError> {
        let user = User(username: username)
        currentUser = user
        return Future { promise in
            promise(.success(user))
        }
    }

    func logout() -> Future<Void, Never> {
        currentUser = nil
        return Future { promise in promise(.success(())) }
    }
}
