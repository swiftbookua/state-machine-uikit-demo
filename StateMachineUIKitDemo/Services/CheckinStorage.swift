//
//  CheckinStorage.swift
//  StateMachinesSwiftUI
//
//  Created by Vyacheslav Volodko on 22.07.2020.
//

import Combine
import Foundation

struct Checkin: Hashable, Equatable {
    var name: String
    var imageName: String
}

extension Checkin {
    static var preview = Checkin(name: "Bogdan", imageName: "bogdan")
}

enum CheckinDataSourceError: Error {
    case failedToLoadData
    case noAuth
}

protocol CheckinDataService {
    func fetchCheckins() -> Future<[Checkin], CheckinDataSourceError>
}

class MockCheckinDataService: CheckinDataService {
    // MARK: - DI

    private let authManager: AuthManager
    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    // MARK: - CheckinDataSource

    func fetchCheckins() -> Future<[Checkin], CheckinDataSourceError> {
        return .init { [weak self] promise in
            guard let strongSelf = self else { return }

            if let user = strongSelf.authManager.currentUser {

                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    if let checkins = strongSelf.data[user] {
                        promise(.success(checkins))
                    } else {
                        promise(.failure(.failedToLoadData))
                    }
                }
            } else {
                promise(.failure(.noAuth))
            }
        }
    }
    
    // MARK: - Private
    
    private let data: [User: [Checkin]] = [
        User(username: "killobatt"): [
            Checkin(name: "Церква у селі Суботів", imageName: "bogdan-sleep.jpg"),
            Checkin(name: "Пам'ятник Богдану Хмельницькому", imageName: "bogdan.jpg"),
            Checkin(name: "Церква Павла Полуботка в Холодному Яру", imageName: "cold-yar.jpg"),
            Checkin(name: "Церква у селі Мошни", imageName: "moshny.jpg"),
            Checkin(name: "Мотронинський Монастир у Холодному Яру", imageName: "motronynsky.jpg")
        ],
        User(username: "vasyl"): []
    ]

    static let mockCheckins: [Checkin] = [
        Checkin(name: "Церква у селі Суботів", imageName: "bogdan-sleep.jpg"),
        Checkin(name: "Пам'ятник Богдану Хмельницькому", imageName: "bogdan.jpg"),
        Checkin(name: "Церква Павла Полуботка в Холодному Яру", imageName: "cold-yar.jpg"),
        Checkin(name: "Церква у селі Мошни", imageName: "moshny.jpg"),
        Checkin(name: "Мотронинський Монастир у Холодному Яру", imageName: "motronynsky.jpg")
    ]
}
