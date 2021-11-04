//
//  MountainAnnotationView.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit
import MapKit

class MountainAnnotationView: MKMarkerAnnotationView {
    static let ReuseID = "MountainAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = "mountain"
        self.canShowCallout = true
        self.calloutOffset = CGPoint(x: 0, y: 5)
        self.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = .blue
        glyphImage = UIImage(systemName: "play.fill")
    }
}
