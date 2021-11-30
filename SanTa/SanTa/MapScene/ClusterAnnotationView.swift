//
//  ClusterAnnotationView.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import MapKit

final class ClusterAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let cluster = annotation as? MKClusterAnnotation {
            let count = cluster.memberAnnotations.count

            image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
                UIColor.white.setFill()
                UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 30, height: 30)).fill()
                UIColor(named: "SantaColor")?.setFill()
                UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: 24, height: 24)).fill()

                let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11)]
                let text = count > 99 ? "99+" : "\(count)"
                let size = text.size(withAttributes: attributes)
                let rect = CGRect(x: 15 - size.width / 2, y: 15 - size.height / 2, width: size.width, height: size.height)
                text.draw(in: rect, withAttributes: attributes)
            }
        }
    }
}
