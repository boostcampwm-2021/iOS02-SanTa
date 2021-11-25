//
//  PinView.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/25.
//

import MapKit

class PinView: MKAnnotationView {
    static let ReuseID = "PinView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.centerOffset = CGPoint(x: 0, y: -20)
        self.canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        self.image = UIImage(systemName: "mappin")
        self.frame = CGRect(x: 0, y: 0, width: 15, height: 40)
    }
}
