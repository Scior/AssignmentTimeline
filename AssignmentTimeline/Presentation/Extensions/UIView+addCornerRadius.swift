//
//  UIView+addCornerRadius.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import UIKit

extension UIView {
    func addCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
