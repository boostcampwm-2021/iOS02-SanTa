//
//  MapOptionCell.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/02.
//

import UIKit

class MapOptionCell: UITableViewCell {
    
    static let identifier = "MapOptionCell"
    
    private(set) var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var map: UILabel = {
        let label = PaddingLabel()
        label.padding(top: 5, bottom: 5, left: 10, right: 10)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.backgroundColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let newWidth = frame.width * 0.90
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space
            super.frame = frame
        }
    }

    private func configureView() {
        self.contentView.addSubview(self.title)
        let locationConstrain = [
            self.title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30),
        ]
        NSLayoutConstraint.activate(locationConstrain)
        
        self.contentView.addSubview(self.map)
        let mapConstrain = [
            self.map.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.map.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -30),
        ]
        NSLayoutConstraint.activate(mapConstrain)
    }
    
    func update(option: MapOption) {
        self.title.text = option.text
        self.map.text = option.map.description
    }
}
