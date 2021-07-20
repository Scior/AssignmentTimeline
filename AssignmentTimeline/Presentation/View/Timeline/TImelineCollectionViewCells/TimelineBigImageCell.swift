//
//  TimelineBigImageCell.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/19.
//

import Foundation
import SDWebImage
import UIKit

final class TimelineBigImageCell: UICollectionViewCell, ReusableCell {
    enum Const {
        // パフォーマンスのため、厳密な高さを計算しておく
        static var height: CGFloat {
            return articleImageViewHeight
                + titleLabelHeight
                + TimelineCommentUserView.Const.height
                + TimelinePickUsersView.Const.height
                + verticalStackViewSpacing * 2
                + verticalInset * 2
        }
        static var articleImageViewHeight: CGFloat {
            return TimelineViewController.Const.cellWidth * 2 / 5
        }
        static let titleLabelHeight: CGFloat = 48
        static let verticalStackViewSpacing: CGFloat = 4
        static let verticalInset: CGFloat = 8
    }

    // MARK: - Properties

    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = Const.verticalStackViewSpacing

        return stackView
    }()
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 2

        return label
    }()
    private let topCommentUserView = TimelineCommentUserView()
    private let pickUsersView = TimelinePickUsersView()

    // MARK: - Lifecycle

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.addCornerRadius(4)

        contentView.addSubview(articleImageView)
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleImageView.heightAnchor.constraint(equalToConstant: Const.articleImageViewHeight),
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: Const.verticalInset),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Const.verticalInset),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            verticalStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        verticalStackView.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: Const.titleLabelHeight).isActive = true

        verticalStackView.addArrangedSubview(topCommentUserView)
        verticalStackView.addArrangedSubview(pickUsersView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        articleImageView.image = nil
        titleLabel.text = nil
        topCommentUserView.reset()
        pickUsersView.reset()
    }

    // MARK: - Methods

    func setup(item: TimelineItem) {
        articleImageView.sd_setImage(with: URL(string: item.image), placeholderImage: .lightGrayFilled)

        if let title = item.title {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 4
            style.lineBreakMode = .byTruncatingTail
            titleLabel.attributedText = NSAttributedString(string: title, attributes: [.paragraphStyle: style])
        }
        if let comment = item.topComment {
            topCommentUserView.setup(comment: comment)
        }
        if let users = item.pickUsers, let pickCount = item.pickCount {
            pickUsersView.setup(users: users, pickCount: pickCount)
        }
    }
}
