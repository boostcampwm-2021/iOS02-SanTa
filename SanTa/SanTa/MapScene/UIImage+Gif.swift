//
//  UIImage+Gif.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/08.
//
//  참고: https://github.com/kiritmodi2702/GIF-Swift/blob/master/GIF-Swift/iOSDevCenters%2BGIF.swift

import UIKit

extension UIImage {
    class func gifImage(named: String, withTintColor: UIColor? = nil) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: named, withExtension: "gif"),
              let imageData = try? Data(contentsOf: bundleURL),
              let source = CGImageSourceCreateWithData(imageData as CFData, nil)
        else { return nil }
        return UIImage.animatedImageWithSource(source, withTintColor: withTintColor)
    }

    private class func animatedImageWithSource(_ source: CGImageSource, withTintColor: UIColor?) -> UIImage? {
        let count: Int = CGImageSourceGetCount(source)
        let images: [UIImage] = (0..<count).compactMap {
            CGImageSourceCreateImageAtIndex(source, $0, nil)
        }.map {
            if let tintColor = withTintColor {
                return UIImage(cgImage: $0).withTintColor(tintColor)
            } else {
                return UIImage(cgImage: $0)
            }
        }
        let time: TimeInterval = 0.05 * Double(images.count)

        return UIImage.animatedImage(with: images, duration: time)
    }
}
