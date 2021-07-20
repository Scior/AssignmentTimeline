//
//  TimelineUserImageView.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import UIKit

final class TimelineUserImageView: UIImageView {
    private let size: CGFloat

    override var intrinsicContentSize: CGSize {
        return .init(width: size, height: size)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(size: CGFloat) {
        self.size = size
        super.init(frame: .zero)

        contentMode = .scaleAspectFill
        addCornerRadius(size / 2)
    }
}
