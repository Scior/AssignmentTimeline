//
//  TimelinePickUsersView.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import SDWebImage
import UIKit

final class TimelinePickUsersView: UIView {
    enum Const {
        static let height: CGFloat = 30
        static let userIconImageSize: CGFloat = 20
        static let userIconSpacing: CGFloat = -4
        static let userIconMaxCount = 3
        static let userIconStackViewWidth = calcUserIconStackViewWidth(iconCount: userIconMaxCount)

        static func calcUserIconStackViewWidth(iconCount: Int) -> CGFloat {
            guard iconCount > 0 else {
                return 0
            }
            return Const.userIconImageSize * CGFloat(iconCount) + Const.userIconSpacing * CGFloat(iconCount - 1)
        }
    }

    // MARK: - Properties

    private let userIconStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Const.userIconSpacing
        stackView.distribution = .fillProportionally
        return stackView
    }()
    private let pickCountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    private var userIconStackViewWidthConstraint: NSLayoutConstraint?

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

        addSubview(userIconStackView)
        userIconStackView.translatesAutoresizingMaskIntoConstraints = false
        let userIconStackViewWidthConstraint = userIconStackView.widthAnchor.constraint(equalToConstant: Const.userIconStackViewWidth)
        self.userIconStackViewWidthConstraint = userIconStackViewWidthConstraint
        NSLayoutConstraint.activate([
            userIconStackViewWidthConstraint,
            userIconStackView.heightAnchor.constraint(equalToConstant: Const.userIconImageSize),
            userIconStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userIconStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        addSubview(pickCountLabel)
        pickCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            pickCountLabel.leadingAnchor.constraint(equalTo: userIconStackView.trailingAnchor, constant: 8),
            pickCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Methods

    func reset() {
        for arrandedSubview in userIconStackView.arrangedSubviews {
            userIconStackView.removeArrangedSubview(arrandedSubview)
            arrandedSubview.removeFromSuperview()
        }
        pickCountLabel.text = nil
    }

    func setup(users: [User], pickCount: Int) {
        let countLabelSuffix = pickCount > 1 ? "Picks" : "Pick"
        let attributedString = NSMutableAttributedString(string: String(pickCount) + " ")
        attributedString.append(.init(string: countLabelSuffix, attributes: [
            .foregroundColor: UIColor(white: 0.5, alpha: 1),
            .font: UIFont.systemFont(ofSize: 12)
        ]))
        pickCountLabel.attributedText = attributedString

        let iconCount = users.prefix(Const.userIconMaxCount).count
        userIconStackViewWidthConstraint?.constant = Const.calcUserIconStackViewWidth(iconCount: iconCount)

        for user in users.prefix(Const.userIconMaxCount) {
            let imageView = TimelineUserImageView(size: Const.userIconImageSize)
            imageView.sd_setImage(with: URL(string: user.image), placeholderImage: .lightGrayFilled)
            userIconStackView.addArrangedSubview(imageView)
        }
    }
}
