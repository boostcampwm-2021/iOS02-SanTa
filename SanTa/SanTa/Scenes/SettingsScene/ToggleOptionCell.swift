//
//  SettingsCell.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/01.
//

import UIKit

protocol ToggleOptionCellDelegate: AnyObject {
    func toggleOptionCellSwitchChanged(_ cell: ToggleOptionCell, title: String, switchOn: Bool)
}

final class ToggleOptionCell: UITableViewCell {

    static let identifier = "ToggleOptionCell"

    weak var delegate: ToggleOptionCellDelegate?

    private var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.init(rawValue: 800), for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private var controlSwitch: UISwitch = {
        let controlSwitch = UISwitch()
        controlSwitch.translatesAutoresizingMaskIntoConstraints = false
        controlSwitch.addTarget(self, action: #selector(onClickSwitch(sender:)), for: .valueChanged)
        controlSwitch.onTintColor = UIColor(named: "SantaColor")
        controlSwitch.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .horizontal)
        return controlSwitch
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.title, self.controlSwitch])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onClickSwitch(sender: UISwitch) {
        guard let title = self.title.text else { return }
        self.delegate?.toggleOptionCellSwitchChanged(self,
                                                     title: title,
                                                     switchOn: self.controlSwitch.isOn)
    }

    private func configureView() {
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            self.stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30),
            self.stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -30)
        ])
    }

    func update(option: ToggleOption) {
        self.title.text = option.text
        self.controlSwitch.isOn = option.toggle
    }

    func changeSwitch() {
        self.controlSwitch.isOn.toggle()
        self.onClickSwitch(sender: self.controlSwitch)
        self.accessibilityValue = self.controlSwitch.isOn ? "켜짐" : "꺼짐"
    }
}

// MARK: - Accessibility

extension ToggleOptionCell {
    func configureAccessibility() {
        self.configureDynamicTypeAccessibility()
        self.configureVoiceOverAccessibility()
    }

    private func configureDynamicTypeAccessibility() {
        self.stackView.axis =
        self.traitCollection.preferredContentSizeCategory < .accessibilityLarge ?
            .horizontal : .vertical
    }

    private func configureVoiceOverAccessibility() {
        self.controlSwitch.isAccessibilityElement = false
        guard let title = title.text else { return }
        self.accessibilityLabel = "\(title)"
        self.accessibilityValue = self.controlSwitch.isOn ? "켜짐" : "꺼짐"
        self.accessibilityHint = "설정을 끄거나 켜려면 이중탭 하십시오"
        self.accessibilityIdentifier = "\(title) Cell"
    }
}
