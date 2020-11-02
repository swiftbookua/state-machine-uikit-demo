//
//  CheckinListTableViewCell.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 08.09.2020.
//

import UIKit

class CheckinListTableViewCell: UITableViewCell {

    static let reuseIdentifier = "\(CheckinListTableViewCell.self)"
    static let nib = UINib(nibName: reuseIdentifier, bundle: nil)

    var checkin: Checkin? {
        didSet {
            updateUI()
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var checkinImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }

    // MARK: - Private

    private func updateUI() {
        if let imageName = checkin?.imageName {
            checkinImageView.image = UIImage(named: imageName)
        } else {
            checkinImageView.image = nil
        }
        titleLabel.text = checkin?.name
    }
}
