//
//  MountainFooterView.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/17.
//

import UIKit

final class MountainFooterView: UIView {
    
    static let identifier = "MountainFooterView"
    
    private var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.addSubview(self.footerView)
        let footerViewConstraint = [
            self.footerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.footerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(footerViewConstraint)
        
    }
}
