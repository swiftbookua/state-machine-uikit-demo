//
//  LoginViewController.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 18.09.2020.
//

import UIKit
import Combine

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewController(_ controller: LoginViewController, didLogin user: User)
}

class LoginViewController: UIViewController, StoryboardInstantiatable {

    // MARK: - DI

    weak var delegate: LoginViewControllerDelegate?
    private var authManager: AuthManager = DIContainer.shared.authManager

    // MARK: - IBOutlet

    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        hideLoading()
        hideError()
    }

    // MARK: - Private

    private var loginSubscription: AnyCancellable?

    // MARK: - IBActions

    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let username = loginTextField.text,
              let password = passwordTextField.text else { return }

        hideError()
        showLoading()
        loginSubscription = authManager
            .login(username: username, password: password)
            .catch { [weak self] error -> Empty<User, Never> in
                self?.showError(error)
                self?.hideLoading()
                return Empty<User, Never>()
            }
            .sink { [weak self] (user) in
                self?.notify(loggedIn: user)
                self?.hideLoading()
            }

    }

    private func showLoading() {
        loginButton.isHidden = true
        activityIndicator.isHidden = false
    }

    private func hideLoading() {
        loginButton.isHidden = false
        activityIndicator.isHidden = true
    }

    private func hideError() {
        errorLabel.isHidden = true
        errorLabel.text = nil
    }

    private func showError(_ error: Error) {
        errorLabel.isHidden = false
        errorLabel.text = error.localizedDescription
    }

    private func notify(loggedIn user: User) {
        delegate?.loginViewController(self, didLogin: user)
    }
}
