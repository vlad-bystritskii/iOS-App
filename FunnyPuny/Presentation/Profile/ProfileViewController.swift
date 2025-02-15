// ProfileViewController.swift
// FunnyPuny. Created by Zlata Guseva.

import SwiftDate
import UIKit

class ProfileViewController: ViewController {
    private var profileView = ProfileView()
    private var profileOptions = [Texts.notifications, Texts.appearance, Texts.achievments, Texts.donation]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Texts.profile
        view = profileView
        setupTableView()
    }

    private func setupTableView() {
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }
}

// MARK: UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

// MARK: UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        profileOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ProfileCell.self)
        let viewModel = ProfileCellViewModel(
            itemName: profileOptions[indexPath.row]
        )
        cell.configure(with: viewModel)
        return cell
    }
}
