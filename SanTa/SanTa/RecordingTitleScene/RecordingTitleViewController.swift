//
//  RecordingTitleViewController.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/09.
//

import UIKit

class RecordingTitleViewController: UIViewController {
    weak var coordinator: RecordingTitleViewCoordinator?
    weak var delegate: RecordingViewDelegate?
     
    private var displayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RecordingSubViewBackgroundColor")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let recordingTitle: UILabel = {
        let label = UILabel()
        label.text = "기록 제목"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recordingTitleDescription: UILabel = {
        let label = UILabel()
        label.text = "이 기록에 대한 제목을 입력해주세요."
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recordingTitleText: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 22)
        textField.clearButtonMode = .whileEditing
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let inputButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("입력", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let notInputButton: UIButton = {
        let button = UIButton()
        button.setTitle("입력 안함", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var keyHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureDelegate()
        self.configureNotification()
        self.configureConstraints()
        self.configureTarget()
        self.titleTextFieldUnderLine()
    }
    
    private func configureDelegate() {
        self.recordingTitleText.delegate = self
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureConstraints() {
        let frameWidth = view.frame.width
        let frameHeight = view.frame.height

        self.displayView.frame = CGRect(x: 6, y: frameHeight - frameHeight/2, width: frameWidth - 12, height: frameHeight/3)
        
        [self.recordingTitle, self.recordingTitleDescription, self.recordingTitleText, self.inputButton, self.notInputButton].forEach {
            self.titleStackView.addArrangedSubview($0)
        }
        
        self.view.addSubview(displayView)
        self.displayView.addSubview(titleStackView)
        
        let inputButtonConstraints = [
            self.inputButton.widthAnchor.constraint(equalToConstant: frameWidth - 12)
        ]
        
        let recordingTitleText = [
            self.recordingTitleText.widthAnchor.constraint(equalToConstant: frameWidth - 12)
        ]
        
        let titleStackViewConstraints = [
            self.titleStackView.topAnchor.constraint(equalTo: self.displayView.topAnchor, constant: 16),
            self.titleStackView.leadingAnchor.constraint(equalTo: self.displayView.leadingAnchor, constant: 16),
            self.titleStackView.trailingAnchor.constraint(equalTo: self.displayView.trailingAnchor, constant: -16),
            self.titleStackView.bottomAnchor.constraint(equalTo: self.displayView.bottomAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(recordingTitleText)
        NSLayoutConstraint.activate(inputButtonConstraints)
        NSLayoutConstraint.activate(titleStackViewConstraints)
        
        self.view.layoutIfNeeded()
    }
    
    private func configureTarget() {
        self.inputButton.addTarget(self, action: #selector(inputButtonAction), for: .touchUpInside)
        self.notInputButton.addTarget(self, action: #selector(notInputButtonButtonAction), for: .touchUpInside)
    }
    
    private func titleTextFieldUnderLine() {
        let border = CALayer()
        border.frame = CGRect(x: 1, y: self.recordingTitleText.frame.size.height - 1, width: self.recordingTitleText.frame.width - 1, height: 1)
        border.borderWidth = 1
        border.backgroundColor = UIColor.systemGray2.cgColor
        self.recordingTitleText.layer.addSublayer(border)
    }
    
    @objc private func inputButtonAction(sender: UIButton) {
        guard let title = self.recordingTitleText.text else {
            self.coordinator?.dismiss()
            self.delegate?.didTitleWriteDone(title: "")
            return
        }
        
        self.coordinator?.dismiss()
        self.delegate?.didTitleWriteDone(title: title)
    }
    
    @objc private func notInputButtonButtonAction(sender: UIButton) {
        self.coordinator?.dismiss()
        self.delegate?.didTitleWriteDone(title: "")
    }
    
    deinit {
        print("😇RecordingTitleViewController is deinit \(Date())!!😇")
    }
}

extension RecordingTitleViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if text.count >= 20 && range.length == 0 && range.location >= 20 {
            return false
        }
        
        return true
    }
}

extension RecordingTitleViewController {
    @objc func keyboardWillShow(_ sender: Notification) {
        guard self.keyHeight == nil else { return }
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        keyHeight = keyboardHeight
        
        self.displayView.frame.origin.y -= keyboardHeight
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        guard let keyHeight = keyHeight else { return }
        
        self.displayView.frame.origin.y += keyHeight
        self.keyHeight = nil
    }
}
