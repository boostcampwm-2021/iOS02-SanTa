//
//  PaddingLabel.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/02.
//  참고: https://gist.github.com/konnnn/d43af3bd525bb4c58f5c29fb14575b0d

import UIKit

class PaddingLabel: UILabel {

    var insets = UIEdgeInsets.zero

    convenience init(insets: UIEdgeInsets) {
        self.init()
        self.padding(top: insets.top, bottom: insets.bottom, left: insets.left, right: insets.right)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += self.insets.top + self.insets.bottom
            contentSize.width += self.insets.left + self.insets.right
            return contentSize
        }
    }

    func padding(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: self.frame.width + left + right,
                            height: self.frame.height + top + bottom)
        self.insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
