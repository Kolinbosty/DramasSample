//
//  DramaInfoViewModel.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit

// Note: 基本上跟 ListViewModel 差不多，有再整理的空間？ or Template？
class DramaInfoViewModel: NSObject {
    enum Section {
        case offline
        case dramaInfo
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, BasicCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, BasicCollectionViewCellViewModel>

    private var dataSource: DataSource?
    private let drama: LineTVAPI.Drama

    private weak var collectionView: UICollectionView?

    private var isNetworkConnected: Bool = true

    init(_ drama: LineTVAPI.Drama, collectionView: UICollectionView?) {
        self.drama = drama
        self.collectionView = collectionView
        super.init()

        setupCollectionView()
        startObserveNetwork()
    }

    private func startObserveNetwork() {
        // Only trigger while condition changed
        NetworkMonitor.shared.addObserver { [weak self] (isConnected) -> Bool in
            // Update
            self?.isNetworkConnected = isConnected
            self?.reloadValues()

            // Remove if needed
            return self != nil
        }

        // Current state
        self.isNetworkConnected = NetworkMonitor.shared.isConnected
    }
}

// MARK: - CollectionView
extension DramaInfoViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        guard let collectionView = collectionView else {
            assert(false, "Error: must create collection view first...")
            return
        }

        // Note: 如果新增的 VM 只要加在這邊，下面的 Register 的 loop 會自己跑完。
        let knownVMs: [BasicCollectionViewCellViewModel.Type] = [
            OfflineCellViewModel.self,
            DaramaInfoCellViewModel.self
        ]

        // Register
        knownVMs.forEach { (vmType) in
            collectionView.register(vmType.cellClass(),
                                    forCellWithReuseIdentifier: vmType.cellIdentifier())
        }

        // Create DataSource
        let dataSource = DataSource(collectionView: collectionView) {
            (collectionView, indexPath, vm) -> UICollectionViewCell? in
            // Dequeue & Update
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: vm).cellIdentifier(),
                                                          for: indexPath) as? BasicCollectionViewCell
            cell?.update(with: vm)

            return cell
        }
        self.dataSource = dataSource
    }
}

// MARK: - Operation
extension DramaInfoViewModel {

    /// Construct & Apply Snapshot
    func reloadValues() {
        var snapshot = Snapshot()

        // Network connection
        if !isNetworkConnected {
            snapshot.appendSections([.offline])
            snapshot.appendItems([OfflineCellViewModel()])
        }

        // Info
        snapshot.appendSections([.dramaInfo])
        snapshot.appendItems([DaramaInfoCellViewModel(drama)])

        // Apply
        dataSource?.apply(snapshot)
    }
}
