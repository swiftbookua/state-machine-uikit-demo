//
//  CheckinListLoginPromptViewController.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 08.09.2020.
//

import UIKit

protocol CheckinListLoginPromptDelegate: AnyObject {
    func checkinListLoginPromptDidRequestLogin(_ checkinListLoginPrompt: CheckinListLoginPromptViewController)
}

class CheckinListLoginPromptViewController: UIViewController, StoryboardInstantiatable {

    weak var delegate: CheckinListLoginPromptDelegate?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions

    @IBAction private func loginButtonPressed() {
        delegate?.checkinListLoginPromptDidRequestLogin(self)
    }
}
