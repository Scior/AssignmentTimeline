//
//  TimelineBannerCell.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import Foundation
import SDWebImage
import UIKit

final class TimelineBannerCell: UICollectionViewCell, ReusableCell {
    enum Const {
        static var height: CGFloat {
            return (UIScreen.main.bounds.width - 32) * 26 / 105 + verticalInset * 2 // 画像比26:105 (1:4?)
        }
        static let verticalInset: CGFloat = 8
    }

    // MARK: - Properties

    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    // MARK: - Lifecycle

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.addCornerRadius(4)

        contentView.addSubview(bannerImageView)
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bannerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bannerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

    }

    override func prepareForReuse() {
        super.prepareForReuse()

        bannerImageView.image = nil
    }

    // MARK: - Methods

    func setup(item: TimelineItem) {
        bannerImageView.sd_setImage(with: URL(string: item.image), placeholderImage: .lightGrayFilled)
    }
}
