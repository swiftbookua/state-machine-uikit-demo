//
//  CheckinListTableViewController.swift
//  StateMachineUIKitDemo
//
//  Created by Viacheslav Volodko on 08.09.2020.
//

import UIKit

class CheckinListTableViewController: UITableViewController {

    var items: [Checkin] = [] {
        didSet {
            guard isViewLoaded else { return }
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CheckinListTableViewCell.nib,
                           forCellReuseIdentifier: CheckinListTableViewCell.reuseIdentifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckinListTableViewCell.reuseIdentifier, for: indexPath)

        if let checkinListCell = cell as? CheckinListTableViewCell {
            checkinListCell.checkin = items[indexPath.row]
        }

        return cell
    }
}
