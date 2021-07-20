//
//  UIImage+filled.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import UIKit

extension UIImage {
    static let lightGrayFilled = filled(color: .init(white: 0.96, alpha: 1), size: .init(width: 1, height: 1))

    static func filled(color: UIColor, size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(.init(origin: .zero, size: size))
        }
    }
}
