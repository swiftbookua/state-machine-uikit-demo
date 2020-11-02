//
//  CheckinListLoadingErrorViewController.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 08.09.2020.
//

import UIKit

protocol CheckinListLoadingErrorViewDelegate: AnyObject {
    func checkinListLoadingErrorViewDidRequestRetry()
}

class CheckinListLoadingErrorViewController: UIViewController, StoryboardInstantiatable {

    weak var delegate: CheckinListLoadingErrorViewDelegate?

    var error: Error? {
        didSet {
            guard isViewLoaded else { return }
            updateUI()
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - IBActions

    @IBAction private func retryButtonPressed() {
        delegate?.checkinListLoadingErrorViewDidRequestRetry()
    }

    // MARK: - Private

    private func updateUI() {
        let format = NSLocalizedString("I'm regret to report that your checkin list was not loaded, because: \n%@", comment: "")
        messageLabel.text = String(
            format: format,
            error?.localizedDescription ?? NSLocalizedString("We don't know why", comment: "")
        )
    }
}
