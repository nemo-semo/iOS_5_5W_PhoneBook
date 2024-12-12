//
//  FriendDetailViewController.swift
//  iOS_5_5W_PhoneBook
//
//  Created by t2023-m0072 on 12/12/24.
//

import UIKit

protocol FriendDetailViewControllerDelegate: AnyObject {
    func didSaveContact(_ contact: UserContact)
}

class FriendDetailViewController: UIViewController {
    weak var delegate: FriendDetailViewControllerDelegate?

    private let profileImageView = UIImageView()
    private let nameTextField = UITextField()
    private let phoneNumberTextField = UITextField()
    private let randomImageButton = UIButton()
    private var currentImageUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "연락처 추가"

        // 네비게이션 바 적용 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(didTapSave))

        // 프로필 이미지 뷰
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 60 // 원형
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        // 랜덤 이미지 생성 버튼
        randomImageButton.setTitle("랜덤 이미지 생성", for: .normal)
        randomImageButton.setTitleColor(.systemBlue, for: .normal)
        randomImageButton.addTarget(self, action: #selector(didTapGenerateRandomImage), for: .touchUpInside)
        randomImageButton.translatesAutoresizingMaskIntoConstraints = false

        // 이름 텍스트필드
        nameTextField.placeholder = "이름을 입력하세요"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        // 전화번호 텍스트필드
        phoneNumberTextField.placeholder = "전화번호를 입력하세요"
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false

        // 뷰 추가
        view.addSubview(profileImageView)
        view.addSubview(randomImageButton)
        view.addSubview(nameTextField)
        view.addSubview(phoneNumberTextField)

        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),

            randomImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),

            nameTextField.topAnchor.constraint(equalTo: randomImageButton.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),

            phoneNumberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func didTapGenerateRandomImage() {
        let randomId = Int.random(in: 1...1000)
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomId)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let sprites = json["sprites"] as? [String: Any],
                   let imageUrl = sprites["front_default"] as? String,
                   let imageData = try? Data(contentsOf: URL(string: imageUrl)!) {
                    DispatchQueue.main.async {
                        self.currentImageUrl = imageUrl
                        self.profileImageView.image = UIImage(data: imageData)
                    }
                }
            } catch {
                print("Error fetching random image")
            }
        }.resume()
    }

    @objc private func didTapSave() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            return
        }

        let newContact = UserContact(name: name, phoneNumber: phoneNumber, imageUrl: currentImageUrl)
        delegate?.didSaveContact(newContact)
        navigationController?.popViewController(animated: true)
    }
}
