//
//  FriendListViewController.swift
//  iOS_5_5W_PhoneBook
//
//  Created by t2023-m0072 on 12/12/24.
//

import UIKit

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    private var contacts: [UserContact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "친구 목록"

        // 네비게이션 바의 우측 버튼 (추가 버튼)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didTapAddContact))

        // 테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.rowHeight = 80
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func didTapAddContact() {
        let detailVC = FriendDetailViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        let contact = contacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }
}

// MARK: - FriendDetailViewControllerDelegate
extension FriendListViewController: FriendDetailViewControllerDelegate {
    func didSaveContact(_ contact: UserContact) {
        contacts.append(contact)
        tableView.reloadData()
    }
}
