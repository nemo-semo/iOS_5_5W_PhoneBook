//
//  ViewController.swift
//  iOS_5_5W_PhoneBook
//
//  Created by t2023-m0072 on 12/12/24.
//

import UIKit

protocol PhoneBookViewControllerDelegate: AnyObject {
    func didSaveContact(_ contact: UserContact)
}

class PhoneBookViewController: UIViewController {
    weak var delegate: PhoneBookViewControllerDelegate?

    var contact: UserContact?

    private let profileContainerView = UIView()
    private let profileImageView = UIImageView()
    private let randomImageButton = UIButton(type: .system)
    private let nameTextField = UITextField()
    private let phoneNumberTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = contact == nil ? "연락처 추가" : "연락처 수정"

        // 프로필 컨테이너 뷰 설정
        profileContainerView.layer.cornerRadius = 75 // 크기 150x150의 반지름
        profileContainerView.clipsToBounds = true
        profileContainerView.layer.borderWidth = 2
        profileContainerView.layer.borderColor = UIColor.lightGray.cgColor
        profileContainerView.translatesAutoresizingMaskIntoConstraints = false

        // 프로필 이미지뷰 설정
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.backgroundColor = .lightGray
        profileContainerView.addSubview(profileImageView)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: profileContainerView.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor)
        ])

        // 랜덤 이미지 버튼 설정
        randomImageButton.setTitle("랜덤 이미지 생성", for: .normal)
        randomImageButton.addTarget(self, action: #selector(fetchRandomImage), for: .touchUpInside)

        // 이름 입력 필드 설정
        nameTextField.placeholder = "이름 입력"
        nameTextField.borderStyle = .roundedRect

        // 전화번호 입력 필드 설정
        phoneNumberTextField.placeholder = "전화번호 입력"
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.keyboardType = .phonePad

        // 스택 뷰 설정
        let stackView = UIStackView(arrangedSubviews: [profileContainerView, randomImageButton, nameTextField, phoneNumberTextField])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileContainerView.heightAnchor.constraint(equalToConstant: 150),
            profileContainerView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .done, target: self, action: #selector(saveContact))
    }

    @objc private func fetchRandomImage() {
        let randomID = Int.random(in: 1...1000)
        let apiUrl = "https://pokeapi.co/api/v2/pokemon/\(randomID)"
        guard let url = URL(string: apiUrl) else { return }

        // PokeAPI에서 데이터 가져오기
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let sprites = json["sprites"] as? [String: Any],
                   let imageUrlString = sprites["front_default"] as? String,
                   let imageUrl = URL(string: imageUrlString) {

                    // 이미지 다운로드
                    URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async {
                            self.profileImageView.image = UIImage(data: data)
                        }
                    }.resume()
                }
            } catch {
                print("JSON Parsing Error: \(error)")
            }
        }.resume()
    }

    @objc private func saveContact() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else { return }

        let newContact = UserContact(name: name, phoneNumber: phoneNumber, imageUrl: nil)
        delegate?.didSaveContact(newContact)
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
