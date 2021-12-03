//
//  CollectionViewCell.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import UIKit

final class DetailCell: UICollectionViewCell {
    static let identifier = "DetailCell"

    let title: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .body, weight: .bold)
        label.textColor = .init(named: "SantaColor")
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .init(named: "SantaColor")
        return view
    }()

    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    func layout(data: DetailInformationModel) {
        self.addSubview(self.title)
        self.title.text = data.title
        self.title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        ])

        self.addSubview(self.line)
        self.line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.line.heightAnchor.constraint(equalToConstant: 1),
            self.line.leftAnchor.constraint(equalTo: self.title.rightAnchor, constant: 5),
            self.line.centerYAnchor.constraint(equalTo: self.title.centerYAnchor),
            self.line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
        ])

        self.stack.subviews.forEach { $0.removeFromSuperview() }
        self.addSubview(self.stack)
        for content in data.contents {
            self.stack.addArrangedSubview(UIStackView(content: content))
        }

        self.stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stack.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 30),
            self.stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.stack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            self.stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension UIFont {
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}

extension UIStackView {
    fileprivate convenience init(content: CellContentEntity) {
        self.init()
        self.axis = .horizontal
        self.distribution = .equalCentering

        let contentLabel = UILabel()
        contentLabel.text = content.content
        contentLabel.font = .preferredFont(for: .title1, weight: .bold)

        let contentTitleLabel = UILabel()
        contentTitleLabel.text = content.contentTitle
        contentTitleLabel.font = .preferredFont(forTextStyle: .body)

        self.addArrangedSubview(contentLabel)
        self.addArrangedSubview(contentTitleLabel)
    }
}

// MARK: - Accessibility

extension DetailCell {
    func configureVoiceOverAccessibility() {
        self.isAccessibilityElement = true
        guard let title = self.title.text else { return }
        var label = "\(title)정보. "
        self.stack.arrangedSubviews.forEach {
            let stackView = $0 as? UIStackView
            guard var contentLabel = (stackView?.arrangedSubviews[0] as? UILabel)?.text,
                  let contentTitleLabel = (stackView?.arrangedSubviews[1] as? UILabel)?.text
            else {
                return
            }
            contentLabel = contentLabel == "-" ? "없음" : contentLabel
            label += "\(contentTitleLabel): \(contentLabel), "
        }
        self.accessibilityLabel = label
    }
}
