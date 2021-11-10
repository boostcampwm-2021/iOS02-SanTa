//
//  MountainAnnotation.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/03.
//

import MapKit

class MountainAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    var mountainDescription: String
    var region: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(title: String, subtitle: String, latitude: Double, longitude: Double, mountainDescription: String, region: String) {
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
        self.mountainDescription = mountainDescription
        self.region = region
    }
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.latitude = 0
        self.longitude = 0
        self.mountainDescription = ""
        self.region = ""
    }
}
