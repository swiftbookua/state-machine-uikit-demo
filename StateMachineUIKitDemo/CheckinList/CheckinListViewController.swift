//
//  ViewController.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 08.09.2020.
//

import UIKit

class CheckinListViewController: UIViewController {

    lazy var checkinListInteractor: CheckinListInteractor = DIContainer.shared.makeCheckinListInteractor()
    var stateMachine: CheckinListStateMachine { checkinListInteractor.stateMachine }

    // MARK: - IBOutlets

    @IBOutlet private weak var containerView: UIViewControllerContainerView!
    @IBOutlet private weak var logoutBarButtonItem: UIBarButtonItem!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.parentViewController = self // I'm your father, Luke!

        stateMachine.observer = self
        checkinListInteractor.refresh()
    }

    // MARK: - Private

    @IBAction private func logout() {
        checkinListInteractor.logout()
    }
}

extension CheckinListViewController {

    private func showLoginPrompt() {
        let controller = CheckinListLoginPromptViewController.instantiateFromStoryboard()
        controller.delegate = self
        containerView.childViewController = controller
    }

    private func showError(_ error: Error) {
        let controller = CheckinListLoadingErrorViewController.instantiateFromStoryboard()
        controller.error = error
        controller.delegate = self
        containerView.childViewController = controller
    }

    private func showLoading() {
        containerView.childViewController = CheckinLoadingViewController.instantiateFromStoryboard()
    }

    private func showEmptyListPlaceholder() {
        containerView.childViewController = CheckinListEmptyViewController.instantiateFromStoryboard()
    }

    private func showCheckinList(_ items: [Checkin]) {
        let listViewController = CheckinListTableViewController()
        listViewController.items = items
        containerView.childViewController = listViewController
    }
    
}

extension CheckinListViewController: CheckinListStateMachineObserver {
    func checkinListStateMachine(_ stateMachine: CheckinListStateMachine,
                                 didEnter state: CheckinListStateMachine.State) {
        switch state {
        case .idle:
            break
        case .loggedOut:
            showLoginPrompt()
        case .loading:
            showLoading()
        case let .error(error):
            showError(error)
        case .empty:
            showEmptyListPlaceholder()
        case let .list(items):
            showCheckinList(items)
        }
        logoutBarButtonItem.isEnabled = state != .loggedOut
    }
}

extension CheckinListViewController: CheckinListLoginPromptDelegate {
    func checkinListLoginPromptDidRequestLogin(_ checkinListLoginPrompt: CheckinListLoginPromptViewController) {
        let controller = LoginViewController.instantiateFromStoryboard()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CheckinListViewController: LoginViewControllerDelegate {
    func loginViewController(_ controller: LoginViewController, didLogin user: User) {
        navigationController?.popViewController(animated: true)
        checkinListInteractor.refresh()
    }
}

extension CheckinListViewController: CheckinListLoadingErrorViewDelegate {
    func checkinListLoadingErrorViewDidRequestRetry() {
        checkinListInteractor.refresh()
    }
}
