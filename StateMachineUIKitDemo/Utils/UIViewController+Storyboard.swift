//
//  UIViewController+Storyboard.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 08.09.2020.
//

import UIKit

protocol StoryboardInstantiatable: UIViewController {
    static var storyboardName: String { get }
    static func instantiateFromStoryboard() -> Self
}

extension StoryboardInstantiatable {
    static var storyboardName: String {
        return "\(Self.self)"
    }

    static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }

    static func instantiateFromStoryboard() -> Self {
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Could not instantiate a view controller from storyboard \(storyboardName)")
        }
        guard let typedViewController = viewController as? Self else {
            fatalError("Could not cast a view controller to \(Self.self)")
        }
        return typedViewController
    }
}
