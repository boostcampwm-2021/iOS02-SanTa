//
//  ClusterAnnotationView.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import MapKit

class ClusterAnnotationView: MKAnnotationView {
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
            
            image = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40)).image { _ in
                UIColor.white.setFill()
                UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
                UIColor.blue.setFill()
                UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: 30, height: 30)).fill()
                
                let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
                let text = count > 99 ? "99+" : "\(count)"
                let size = text.size(withAttributes: attributes)
                let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                text.draw(in: rect, withAttributes: attributes)
            }
        }
    }
}
