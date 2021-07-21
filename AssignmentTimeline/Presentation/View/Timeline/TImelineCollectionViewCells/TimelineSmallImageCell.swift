//
//  TimelineSmallImageCell.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import Foundation
import SDWebImage
import UIKit

final class TimelineSmallImageCell: UICollectionViewCell, ReusableCell {
    enum Const {
        static let height: CGFloat = titleLabelHeight
            + TimelineCommentUserView.Const.height
            + TimelinePickUsersView.Const.height
            + verticalStackViewSpacing * 2
            + verticalInset * 2
        static let articleImageViewHeight: CGFloat = 36
        static let articleImageViewWidth: CGFloat = articleImageViewHeight * 3 / 2
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
    private let headlineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.backgroundColor = TimelineViewController.Const.cellBackgroundColor

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
        label.backgroundColor = TimelineViewController.Const.cellBackgroundColor

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

        contentView.backgroundColor = TimelineViewController.Const.cellBackgroundColor
        contentView.addCornerRadius(4)

        contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Const.verticalInset),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Const.verticalInset),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            verticalStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        verticalStackView.addArrangedSubview(headlineStackView)
        headlineStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headlineStackView.heightAnchor.constraint(equalToConstant: Const.titleLabelHeight),
            headlineStackView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            headlineStackView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor)
        ])

        headlineStackView.addArrangedSubview(titleLabel)

        headlineStackView.addArrangedSubview(articleImageView)
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleImageView.widthAnchor.constraint(equalToConstant: Const.articleImageViewWidth),
            articleImageView.heightAnchor.constraint(equalToConstant: Const.articleImageViewHeight)
        ])

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

        titleLabel.text = item.title
        if let comment = item.topComment {
            topCommentUserView.setup(comment: comment)
        }
        if let users = item.pickUsers, let pickCount = item.pickCount {
            pickUsersView.setup(users: users, pickCount: pickCount)
        }
    }
}
