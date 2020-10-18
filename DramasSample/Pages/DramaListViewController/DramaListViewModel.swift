//
//  DramaListViewModel.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit

class DramaListViewModel: NSObject {
    enum Section {
        case offline
        case drama
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, BasicCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, BasicCollectionViewCellViewModel>

    private var dataSource: DataSource?

    private var dramas: [LineTVAPI.Drama] = []

    private weak var collectionView: UICollectionView?
    private weak var emptyResultView: UIView?

    private var currentSearchText: String?
    private var isNetworkConnected: Bool = true

    init(collectionView: UICollectionView?, emptyResultView: UIView?) {
        self.collectionView = collectionView
        self.emptyResultView = emptyResultView
        super.init()

        setupCollectionView()
        startObserveNetwork()
    }

    private func startObserveNetwork() {
        // Only trigger while condition changed
        NetworkMonitor.shared.addObserver { [weak self] (isConnected) -> Bool in
            // Update
            self?.isNetworkConnected = isConnected
            self?.reloadValues(checkEmpty: false)

            // Remove if needed
            return self != nil
        }

        // Current state
        self.isNetworkConnected = NetworkMonitor.shared.isConnected
    }
}

// MARK: - CollectionView
extension DramaListViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        guard let collectionView = collectionView else {
            assert(false, "Error: must create collection view first...")
            return
        }

        // Note: 如果新增的 VM 只要加在這邊，下面的 Register 的 loop 會自己跑完。
        let knownVMs: [BasicCollectionViewCellViewModel.Type] = [
            OfflineCellViewModel.self,
            DramaCellViewModel.self
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

        // Delegate
        collectionView.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let dataSource = dataSource else { return .zero }
        let currentSnapshot = dataSource.snapshot()
        let sectionType = currentSnapshot.sectionIdentifiers[section]

        switch sectionType {
        case .drama:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        case .offline:
            return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
}

// MARK: - Operation
extension DramaListViewModel {
    func fetchDataAndReload(completion: @escaping (Bool) -> Void) {
        LineTVAPI.client.fetchDramas { [self] (result) in
            switch result {
            case .success(let response):
                dramas = response.data
                reloadValues()
                completion(true)

            case .failure(_):
                reloadValues()
                completion(false)
            }
        }
    }

    func search(title: String? = nil) {
        // Update
        currentSearchText = title
        reloadValues()
    }

    /// Construct & Apply Snapshot
    /// - Parameter checkEmpty: Will check empty result or not.
    func reloadValues(checkEmpty: Bool = true) {
        var snapshot = Snapshot()

        // Network connection
        if !isNetworkConnected {
            snapshot.appendSections([.offline])
            snapshot.appendItems([OfflineCellViewModel()])
        }

        // Search matched drama
        var searchResult = dramas
        if let searchText = currentSearchText, !searchText.isEmpty {
            searchResult = dramas.filter { drama in
                return drama.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        }

        // Create Snapshot
        let vms = searchResult.map { DramaCellViewModel($0) }
        snapshot.appendSections([.drama])
        snapshot.appendItems(vms)

        // Apply
        dataSource?.apply(snapshot)

        if checkEmpty {
            // Update empty view state
            emptyResultView?.isHidden = !searchResult.isEmpty
        }
    }
}
