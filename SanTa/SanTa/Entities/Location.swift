//
//  Location.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/30.
//

import Foundation
import CoreLocation

struct Location {
    let latitude: Double
    let longitude: Double
    let altitude: Double

    func distance(to: Location) -> Double {
        let current = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let destination = CLLocation(latitude: to.latitude, longitude: to.longitude)

        return abs(current.distance(from: destination))
    }
}

struct Locations {
    private(set) var locations: [Location]

    init(locations: [Location]) {
        self.locations = locations
    }

    var coordinates: [CLLocationCoordinate2D] {
        return locations.map {CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
    }

    var maxAltitude: Double {
        guard let max = locations.map({$0.altitude}).max() else {
            return 0
        }
        return max
    }

    var minAltitude: Double {
        guard let min = locations.map({$0.altitude}).min() else {
            return 0
        }
        return min
    }

    var firstAltitude: Double {
        guard let first = locations.map({$0.altitude}).first else {
            return 0
        }
        return first
    }

    var lastAltitude: Double {
        guard let last = locations.map({$0.altitude}).last else {
            return 0
        }
        return last
    }

    var startLocation: Location? {
        return locations.first
    }

    var endLocation: Location? {
        return locations.last
    }

    func totalDistance() -> Double {
        var distance: Double = 0
        var prevLocation: Location?
        for location in locations {
            if let prevLocation = prevLocation {
                distance += location.distance(to: prevLocation)
            }
            prevLocation = location
        }
        return distance
    }

    func totalUphillDistance() -> Double {
        var uphillDistance: Double = 0
        var prevLocation: Location?
        for location in locations {
            if let prevLocation = prevLocation {
                let distance = location.distance(to: prevLocation)
                if location.altitude > prevLocation.altitude {
                    uphillDistance += distance
                }
            }
            prevLocation = location
        }

        return uphillDistance
    }

    func totalDownhillDistance() -> Double {
        var downhillDistance: Double = 0
        var prevLocation: Location?
        for location in locations {
            if let prevLocation = prevLocation {
                let distance = location.distance(to: prevLocation)
                if location.altitude < prevLocation.altitude {
                    downhillDistance += distance
                }
            }
            prevLocation = location
        }

        return downhillDistance
    }

    func totalPlainDistance() -> Double {
        var plainDistance: Double = 0
        var prevLocation: Location?
        for location in locations {
            if let prevLocation = prevLocation {
                let distance = location.distance(to: prevLocation)
                if location.altitude == prevLocation.altitude {
                    plainDistance += distance
                }
            }
            prevLocation = location
        }

        return plainDistance
    }

    func totalIncline() -> [Double] {
        var incline: [Double] = []
        var prevLocation: Location?

        for location in locations {
            if let prevLocation = prevLocation {
                let distanceDelta = location.distance(to: prevLocation)
                let altitudeDelta = location.altitude > prevLocation.altitude ? location.altitude - prevLocation.altitude : 0
                if distanceDelta != 0 {
                    incline.append(atan(altitudeDelta / distanceDelta))
                }
            }
            prevLocation = location
        }

        return incline
    }

    func steepestIncline() -> Double {
        var steepest: Double = 0
        var prevLocation: Location?

        for location in locations {
            if let prevLocation = prevLocation {
                let distanceDelta = location.distance(to: prevLocation)
                let altitudeDelta = location.altitude > prevLocation.altitude ? location.altitude - prevLocation.altitude : 0
                if distanceDelta != 0 {
                    let incline = atan(altitudeDelta / distanceDelta)
                    steepest = max(incline, steepest)
                }
            }
            prevLocation = location
        }
        return steepest
    }
}
