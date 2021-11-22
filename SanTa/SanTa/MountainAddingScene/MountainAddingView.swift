//
//  MountainAddingView.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/22.
//

import UIKit

protocol NewPlaceAddable {
    func userDidTypeWrong()
    func newPlaceShouldAdd(title: String, description: String)
}

class MountainAddingView: UIScrollView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "장소 등록하기"
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: PaddingLabel = {
        let label = PaddingLabel(insets: UIEdgeInsets(top: 2, left: 3, bottom: 2, right: 3))
        label.text = "산 이름"
        label.backgroundColor = UIColor(named: "SantaColor")
        label.layer.cornerRadius = 3
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 13)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "산 이름(10글자 제한)"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionLabel: PaddingLabel = {
        let label = PaddingLabel(insets: UIEdgeInsets(top: 2, left: 3, bottom: 2, right: 3))
        label.text = "산 설명"
        label.backgroundColor = UIColor(named: "SantaColor")
        label.layer.cornerRadius = 3
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 13)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "정상, 봉우리, 사찰, 공원 등(10줄, 100자 이내)"
        textView.textColor = UIColor.systemGray3
        textView.font = .systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        return textView
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("장소 등록", for: .normal)
        button.backgroundColor = UIColor.init(named: "SantaColor")
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerTouched), for: .touchUpInside)
        return button
    }()
    
    var newPlaceDelegate: NewPlaceAddable?
    
    func configure() {
        self.isScrollEnabled = true
        self.backgroundColor = .systemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureSubViews()
        self.configureLayout()
    }
    
    
    private func configureSubViews() {
        self.addSubview(titleLabel)
        self.addSubview(nameLabel)
        self.addSubview(nameTextField)
        self.addSubview(descriptionLabel)
        self.addSubview(descriptionTextView)
        self.addSubview(registerButton)
        self.nameTextField.delegate = self
        self.descriptionTextView.delegate = self
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20),
            self.nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            self.nameTextField.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
            self.nameTextField.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.nameTextField.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 20),
            self.descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            self.descriptionTextView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10),
            self.descriptionTextView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.descriptionTextView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20),
            self.descriptionTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            self.registerButton.topAnchor.constraint(equalTo: self.descriptionTextView.bottomAnchor, constant: 20),
            self.registerButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.registerButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20),
            self.registerButton.bottomAnchor.constraint(lessThanOrEqualTo: self.contentLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func registerTouched() {
        guard let title = nameTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, descriptionTextView.textColor != .systemGray3, !description.isEmpty
        else {
            self.newPlaceDelegate?.userDidTypeWrong()
            return
        }
        self.newPlaceDelegate?.newPlaceShouldAdd(title: title, description: description)
    }
}

extension MountainAddingView: UITextFieldDelegate, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count
        return newLength <= 10
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let string = textView.text else { return true }
        let newLength = string.count + text.count
        let newLines = string.filter{$0 == "\n"}.count + text.filter{$0 == "\n"}.count
        return newLength <= 100 && newLines + 1 <= 10
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "정상, 봉우리, 사찰, 공원 등(10줄, 100자 이내)"
            textView.textColor = UIColor.systemGray3
        }
    }
}
