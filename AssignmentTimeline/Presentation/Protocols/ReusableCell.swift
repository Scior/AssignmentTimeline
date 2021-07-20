//
//  ReusableCell.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/20.
//

import UIKit

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func register<T: ReusableCell & UICollectionViewCell>(type: T.Type) {
        register(type, forCellWithReuseIdentifier: T.identifier)
    }

    func dequeue<T: ReusableCell & UICollectionViewCell>(type: T.Type, for indexPath: IndexPath, configure: (T) -> Void) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        if let cell = cell as? T {
            configure(cell)
        }

        return cell
    }
}
