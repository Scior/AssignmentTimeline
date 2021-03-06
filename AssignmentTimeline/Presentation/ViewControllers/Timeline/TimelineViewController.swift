//
//  TimelineViewController.swift
//  AssignmentTimeline
//
//  Created by Fujino Suita on 2021/07/16.
//

import Combine
import ComposableArchitecture
import UIKit

final class TimelineViewController: UIViewController {
    enum Const {
        static var cellWidth: CGFloat {
            return UIScreen.main.bounds.width - 16
        }
        static let cellBackgroundColor = UIColor.white
    }

    // MARK: - Properties

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(type: TimelineBigImageCell.self)
        collectionView.register(type: TimelineSmallImageCell.self)
        collectionView.register(type: TimelineBannerCell.self)
        collectionView.alwaysBounceVertical = true

        return collectionView
    }()
    private let refreshControl = UIRefreshControl()

    private let viewStore: ViewStore<TimelineState, TimelineAction>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(store: Store<TimelineState, TimelineAction>) {
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .init(white: 0.98, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadItems(sender:)), for: .valueChanged)

        // MARK: ViewStore

        viewStore.send(.fetchNextPage)

        viewStore.publisher.items
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewStore.publisher.items
            .map(\.isEmpty)
            .removeDuplicates()
            .filter { !$0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self, self.refreshControl.isRefreshing  else {
                    return
                }

                self.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
    }

    // MARK: - Methods

    private func getItem(at indexPath: IndexPath) -> TimelineItem? {
        guard indexPath.section == 0, viewStore.items.indices.contains(indexPath.row) else {
            assertionFailure("indexPath is out of range")
            return nil
        }

        return viewStore.items[indexPath.row]
    }

    @objc
    private func reloadItems(sender: UIRefreshControl) {
        viewStore.send(.reloadItems)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TimelineViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        assert(indexPath.section == 0, "Section must be 0")
        viewStore.send(.hasReadItem(index: indexPath.row))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = getItem(at: indexPath) else {
            return
        }

        // link??????????????????????????????????????????????????????
        if let url = item.link.flatMap(URL.init(string:)),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = getItem(at: indexPath) else {
            return .init()
        }

        let height: CGFloat
        switch item.type {
        case .bigImage:
            height = TimelineBigImageCell.Const.height
        case .smallImage:
            height = TimelineSmallImageCell.Const.height
        case .banner:
            height = TimelineBannerCell.Const.height
        }

        return .init(width: Const.cellWidth, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 0, bottom: 8, right: 0)
    }
}

// MARK: - UICollectionViewDataSource

extension TimelineViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assert(section == 0, "Section must be 0")
        return viewStore.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = getItem(at: indexPath) else {
            return .init()
        }

        let cell: UICollectionViewCell
        switch item.type {
        case .bigImage:
            cell = collectionView.dequeue(type: TimelineBigImageCell.self, for: indexPath) { cell in
                cell.setup(item: item)
            }
        case .smallImage:
            cell = collectionView.dequeue(type: TimelineSmallImageCell.self, for: indexPath) { cell in
                cell.setup(item: item)
            }
        case .banner:
            cell = collectionView.dequeue(type: TimelineBannerCell.self, for: indexPath) { cell in
                cell.setup(item: item)
            }
        }

        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 4
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = .init(width: 2, height: 2)
        cell.layer.masksToBounds = false

        return cell
    }
}

// To improve: UICollectionViewDataSourcePrefetching
