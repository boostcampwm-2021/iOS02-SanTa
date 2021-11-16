//
//  MountainDetailCategoryLabel.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/15.
//  출처: https://ios-development.tistory.com/698

import UIKit

class MountainDetailCategoryLabel: UILabel {
    private var defaultPadding = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.defaultPadding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: defaultPadding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += defaultPadding.top + defaultPadding.bottom
        contentSize.width += defaultPadding.left + defaultPadding.right

        return contentSize
    }
}
