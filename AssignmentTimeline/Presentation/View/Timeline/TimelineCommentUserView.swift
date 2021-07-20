//
//  TimelineCommentUserView.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import UIKit

final class TimelineCommentUserView: UIView {
    enum Const {
        static let height: CGFloat = 48
        static let userImageSize: CGFloat = 44
    }

    // MARK: - Properties

    private let userImageView = TimelineUserImageView(size: Const.userImageSize)
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()

    override var intrinsicContentSize: CGSize {
        return .init(width: UIView.noIntrinsicMetric, height: Const.height)
    }

    // MARK: - Lifecycle

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = false

        addSubview(userImageView)
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: Const.userImageSize),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
            userImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentLabel.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor)
        ])
    }

    // MARK: - Methods

    func reset() {
        userImageView.image = nil
        userNameLabel.text = nil
        commentLabel.text = nil
    }

    func setup(comment: Comment) {
        userImageView.sd_setImage(with: URL(string: comment.user.image), placeholderImage: .lightGrayFilled)
        userNameLabel.text = comment.user.name
        commentLabel.text = comment.comment
    }
}
