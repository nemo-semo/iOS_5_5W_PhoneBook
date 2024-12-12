//
//  AddContactViewController.swift
//  iOS_5_5W_PhoneBook
//
//  Created by t2023-m0072 on 12/12/24.
//

import UIKit

class FriendCell: UITableViewCell {
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let phoneNumberLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // 프로필 이미지 설정
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30 // 원형(높이/2)
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        // 이름 레이블 설정
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // 전화번호 레이블 설정
        phoneNumberLabel.font = .systemFont(ofSize: 14, weight: .regular)
        phoneNumberLabel.textColor = .gray
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false

        // 셀 내부에 요소 추가
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneNumberLabel)

        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),

            phoneNumberLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
        ])
    }

    func configure(with contact: UserContact) {
        nameLabel.text = contact.name
        phoneNumberLabel.text = contact.phoneNumber

        // 프로필 이미지 로드
        if let imageUrl = contact.imageUrl, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            profileImageView.image = UIImage(systemName: "person.circle") // 기본 이미지
        }
    }
}
