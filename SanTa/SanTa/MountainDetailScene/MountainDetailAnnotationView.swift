//
//  MountainDetailAnnotationView.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/15.
//

import UIKit
import MapKit

class MountainnDetailAnnotationView: MKAnnotationView {
    static let ReuseID = "MountainDetailAnnotationView"
    let imageSideLength: CGFloat = 30

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
        self.calloutOffset = CGPoint(x: imageSideLength / 2, y: -imageSideLength / 4)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        self.image = UIImage(named: "SantaImage")
        self.frame = CGRect(x: 0, y: 0, width: imageSideLength, height: imageSideLength)
    }
}
